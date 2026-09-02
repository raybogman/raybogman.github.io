//
// Copy page — Markdown twin widget
//
// Vanilla, dependency-free. Uses delegated listeners on `document` so it keeps
// working after the site's pjax swaps out `.page__content`. The "Open Markdown"
// link is a real <a class="js-no-ajax"> handled by the site's own navigation.
//

(function () {
	'use strict';

	function widgetOf(el) {
		return el.closest('.js-copymd');
	}

	function writeClipboard(text) {
		if (navigator.clipboard && window.isSecureContext) {
			return navigator.clipboard.writeText(text);
		}
		// Fallback for non-secure contexts (e.g. plain-http local preview).
		return new Promise(function (resolve, reject) {
			var ta = document.createElement('textarea');
			ta.value = text;
			ta.setAttribute('readonly', '');
			ta.style.position = 'absolute';
			ta.style.left = '-9999px';
			document.body.appendChild(ta);
			ta.select();
			try {
				document.execCommand('copy');
				resolve();
			} catch (err) {
				reject(err);
			}
			document.body.removeChild(ta);
		});
	}

	function flash(widget, msg) {
		var label = widget.querySelector('.copymd__label');
		if (label) {
			if (label.dataset.orig === undefined) {
				label.dataset.orig = label.textContent;
			}
			label.textContent = msg;
		}
		widget.classList.add('copymd--flash');
		clearTimeout(widget._flashTimer);
		widget._flashTimer = setTimeout(function () {
			if (label) {
				label.textContent = label.dataset.orig;
			}
			widget.classList.remove('copymd--flash');
		}, 1600);
	}

	function copyMarkdown(widget) {
		var url = widget.getAttribute('data-md-url');
		if (!url) {
			return;
		}
		fetch(url, { headers: { Accept: 'text/markdown, text/plain, */*' } })
			.then(function (res) {
				if (!res.ok) {
					throw new Error('HTTP ' + res.status);
				}
				return res.text();
			})
			.then(function (text) {
				return writeClipboard(text);
			})
			.then(function () {
				flash(widget, 'Copied!');
			})
			.catch(function () {
				flash(widget, 'Copy failed');
			})
			.then(function () {
				closeMenu(widget);
			});
	}

	function toggleMenu(widget) {
		var menu = widget.querySelector('.copymd__menu');
		var toggle = widget.querySelector('.js-copymd-toggle');
		if (!menu) {
			return;
		}
		var willOpen = menu.hidden;
		menu.hidden = !willOpen;
		if (toggle) {
			toggle.setAttribute('aria-expanded', String(willOpen));
		}
	}

	function closeMenu(widget) {
		if (!widget) {
			return;
		}
		var menu = widget.querySelector('.copymd__menu');
		var toggle = widget.querySelector('.js-copymd-toggle');
		if (menu) {
			menu.hidden = true;
		}
		if (toggle) {
			toggle.setAttribute('aria-expanded', 'false');
		}
	}

	document.addEventListener('click', function (e) {
		var copyBtn = e.target.closest('.js-copymd-copy');
		if (copyBtn) {
			e.preventDefault();
			copyMarkdown(widgetOf(copyBtn));
			return;
		}

		var toggle = e.target.closest('.js-copymd-toggle');
		if (toggle) {
			e.preventDefault();
			toggleMenu(widgetOf(toggle));
			return;
		}

		// A click anywhere else closes any open menus. "Open Markdown" (an <a>)
		// falls through to here and navigates via the site's own link handler.
		var current = widgetOf(e.target);
		var widgets = document.querySelectorAll('.js-copymd');
		for (var i = 0; i < widgets.length; i++) {
			if (widgets[i] !== current) {
				closeMenu(widgets[i]);
			}
		}
	});

	document.addEventListener('keydown', function (e) {
		if (e.key === 'Escape' || e.key === 'Esc') {
			var widgets = document.querySelectorAll('.js-copymd');
			for (var i = 0; i < widgets.length; i++) {
				closeMenu(widgets[i]);
			}
		}
	});
})();

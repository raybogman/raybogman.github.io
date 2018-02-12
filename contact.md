---
layout: page
title: Contact
permalink: /contact/
---

<main class="flex flex-wrap justify-around align-item items-center" markdown="0">
<form id="contactform" action-xhr="//formspree.io/hello@raybogman.com" method="POST">
  <input type="hidden" name="redirect_to" value="//raybogman.com/thanks/">
  <div class="flex flex-column items-center">
    <div class="ampstart-input inline-block relative m0 p0 mb3 ">
      <input type="email" name="email" id="ip1" class="block border-none p0 m0 user-valid valid" placeholder="Your email">
      <label for="ip1" class="absolute top-0 right-0 bottom-0 left-0" aria-hidden="true">Your email</label>
    </div>
  </div>  
  <div class="ampstart-input inline-block relative m0 p0 mb3 ">
    <textarea name="message" class="block border-none p0 m0 user-valid valid" id="ip2" placeholder="Your message"></textarea>
    <label for="ip2" class="absolute top-0 right-0 bottom-0 left-0" aria-hidden="true">Your message</label>
  </div>
  <div>
    <button id="sendBtn" class="ampstart-btn" type="submit">Send</button>
  </div>
</form>
</main>

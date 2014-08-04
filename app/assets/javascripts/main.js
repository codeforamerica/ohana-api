$(document).ready( function(){
  var $signIn      = $(".sign-in");
  var $signUp      = $(".sign-up");
  var $signUpForm  = $(".sign-up-form");
  var $signInForm  = $(".sign-in-form");
  var $optionTab   = $("p");
  var locPathname  = this.location.pathname;
  //checking for for whether or not we're signing in or signing up

  if (locPathname[locPathname.length - 1] == "n") {
    $signUpForm.hide();
    $signIn.addClass("active");
  } else {
    $signInForm.hide();
    $signUp.addClass("active");
  }

  //checking which tab is being clicked, and switching
  //forms accordingly
  $optionTab.on("click", function(evt){
    evt.preventDefault();
    var text = this.textContent[this.textContent.length - 1];

    if ( text === 'n'){
      $signIn.addClass("active");
      $signUp.removeClass("active");
      $signInForm.show();
      $signUpForm.hide();
    } else {
      $signUp.addClass("active");
      $signIn.removeClass("active");
      $signUpForm.show();
      $signInForm.hide();
    }
  });
});


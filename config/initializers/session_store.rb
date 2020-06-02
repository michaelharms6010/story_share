# Be sure to restart your server when you modify this file.

StoryShare::Application.config.session_store :cookie_store,  {
  key:   '_story_share_session',
  :expire_after =>   5.minutes,
  :secure =>         true
  #:httponly =>      true,
  #:cookie_only =>   true
}

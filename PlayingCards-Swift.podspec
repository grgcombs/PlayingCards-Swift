Pod::Spec.new do |s|
  s.name             = "PlayingCards-Swift"
  s.version          = "0.1.0"
  s.summary          = "A complete deck of playing cards, in Swift."
  s.description      = <<-DESC
      This project is an exploration of the data structures and syntax of the Swift language. 
      Anyone and everyone is welcome to participate in this exploration.  This is social coding, after all.
      The theme of this exploration is a deck of playing cards.
                       DESC
  s.homepage         = "https://github.com/grgcombs/PlayingCards-Swift"
  # s.screenshots     = "www.sleestacks.com/playingCards/screenshots_1", "www.sleestacks.com/playingCards/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Greg Combs" => "gcombs@gmail.com" }
  s.source           = { :git => "https://github.com/grgcombs/PlayingCards-Swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/grgcombs'

  s.platform     = :ios, '8.3'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PlayingCards-Swift' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end

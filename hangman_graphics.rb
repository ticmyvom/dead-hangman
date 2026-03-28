# frozen_string_literal: true

# rubocop:disable Layout/TrailingWhitespace
# so that the heredoc NOTHING is displayed properly and rubocop won't complain
HANGMAN_STAGES = [
  <<~ARM2,
    ____________
       \\O/   |
        |    |
       / \\   |
             |
  ARM2

  <<~ARM1,
    ____________
       \\O    |
        |    |
       / \\   |
             |
  ARM1

  <<~LEG2,
    ____________
        O    |
        |    |
       / \\   |
             |
  LEG2

  <<~LEG1,
    ____________
        O    |
        |    |
       /     |
             |
  LEG1

  <<~BODY,
    ____________
        O    |
        |    |
             |
             |
  BODY

  <<~HEAD,
    ____________
        O    |
             |
             |
             |
  HEAD

  <<~BAR,
    ____________
             |
             |
             |
             |
  BAR

  <<-PILLAR,
    
         |
         |
         |
         |
  PILLAR

  <<~NOTHING
    
    
    
    
    
  NOTHING
].freeze
# rubocop:enable Layout/TrailingWhitespace

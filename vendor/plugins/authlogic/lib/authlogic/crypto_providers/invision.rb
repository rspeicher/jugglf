require 'digest/md5'

module Authlogic
  module CryptoProviders
    class InvisionPowerBoard
      class << self
        def encrypt(*tokens)
          tokens = tokens.flatten
          digest = tokens.shift
          digest = filter_input(digest)
          
          # Invision's hash: MD5(MD5(salt) + MD5(raw))
          digest = Digest::MD5.hexdigest(Digest::MD5.hexdigest(tokens.join('')) + Digest::MD5.hexdigest(digest))
          
          digest
        end
    
        # Does the crypted password match the tokens? Uses the same tokens that were used to encrypt.
        def matches?(crypted, *tokens)
          encrypt(*tokens) == crypted
        end
        
        private
          def filter_input(input)
            # Invision's input filtering replaces a bunch of characters before
            # the password gets hashed, some of which may be used in a strong 
            # password. We have to apply the same changes so that the md5'd 
            # string ends up the same on our end
            input.gsub!('&[^amp;]?', '&amp;')
            input.gsub!('<!--', '&#60;&#33;--')
            input.gsub!('-->', '--&#62;')
            input.gsub!(/<script/i, '&#60;script')
            input.gsub!('>', '&gt;')
            input.gsub!('<', '&lt;')
            input.gsub!('"', '&quot;')
            input.gsub!("\\\$", '&#036;')
            input.gsub!('!', '&#33;')
            input.gsub!("'", '&#39;')

            # NOTE: Invision does these, but I doubt they'll show up in a real user's password
            # input.gsub!("\n", '<br />')
            # input.gsub!("\r", '')

            input
          end
      end
    end
  end
end
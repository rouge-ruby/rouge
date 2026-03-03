describe Rouge::Lexers::Berry do
	let(:subject) { Rouge::Lexers::Berry.new }
	describe 'guessing' do
		include Support::Guessing
		it 'guesses by filename' do
			assert_guess :filename => 'foo.be'
		end
		it 'guesses by mimetype' do
			assert_guess :mimetype => 'text/x-berry'
			assert_guess :mimetype => 'application/x-berry'
		end
		it 'guesses by source' do
			assert_guess :source => '#!/usr/bin/env berry'
			assert_guess :source => '#!/usr/bin/berry1'
			assert_guess :source => '#!/usr/bin/berry1.1'
			assert_guess :source => '#!/usr/local/bin/berry10'
			deny_guess   :source => '#!/usr/bin/env be'
		end
	end
end

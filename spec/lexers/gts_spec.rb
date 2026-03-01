# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Gts do
  let(:subject) { Rouge::Lexers::Gts.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'app/components/ui/form.gts'
      assert_guess :filename => 'app/templates/form.gts'
      assert_guess :filename => 'tests/integration/components/ui/form-test.gts'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gts'
      assert_guess :mimetype => 'application/x-gts'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes the opening <template> tag' do
      assert_tokens_equal '<template>',
        ["Name.Tag", "<"], ["Keyword", "template"], ["Name.Tag", ">"]
    end

    it 'lexes the closing </template> tag' do
      assert_tokens_equal '<template></template>',
        ["Name.Tag", "<"], ["Keyword", "template"], ["Name.Tag", "></"], ["Keyword", "template"], ["Name.Tag", ">"]
      assert_tokens_equal '<template> </template>',
        ["Name.Tag", "<"], ["Keyword", "template"], ["Name.Tag", ">"], ["Text", " "], ["Name.Tag", "</"], ["Keyword", "template"], ["Name.Tag", ">"]
    end

    it 'lexes a Glimmer component' do
      code = <<~FILE
        import Component from '@glimmer/component';
        import { t } from 'ember-intl';

        interface HelloSignature {
          Args: {
            name: string;
          };
        }

        export default class Hello extends Component<HelloSignature> {
          <template>
            <div data-test-message>
              {{t "hello.message" name=@name}}
            </div>
          </template>
        }
      FILE

      assert_no_errors code
    end

    it 'lexes a template-only component (1)' do
      code = <<~FILE
        import type { TOC } from '@ember/component/template-only';
        import { t } from 'ember-intl';

        interface HelloSignature {
          Args: {
            name: string;
          };
        }

        const Hello: TOC<HelloSignature> = <template>
          <div data-test-message>
            {{t "hello.message" name=@name}}
          </div>
        </template>;

        export default Hello;
      FILE

      assert_no_errors code
    end

    it 'lexes a template-only component (2)' do
      code = <<~FILE
        import type { TOC } from '@ember/component/template-only';
        import { t } from 'ember-intl';

        interface HelloSignature {
          Args: {
            name: string;
          };
        }

        <template>
          <div data-test-message>
            {{t "hello.message" name=@name}}
          </div>
        </template> satisfies TOC<HelloSignature>;
      FILE

      assert_no_errors code
    end

    it 'lexes a rendering test' do
      code = <<~FILE
        import { render } from '@ember/test-helpers';
        import { setupIntl } from 'ember-intl/test-support';
        import { setupRenderingTest } from 'ember-qunit';
        import Hello from 'my-app/components/hello';
        import { module, test } from 'qunit';

        module('Integration | Component | hello', function (hooks) {
          setupRenderingTest(hooks);
          setupIntl(hooks, 'en-us');

          test('it renders', async function (assert) {
            await render(
              <template>
                <Hello @name="Zoey" />
              </template>
            );

            assert.dom('[data-test-message]').hasText('Hello, Zoey!');
          });
        });
      FILE

      # Currently unable to assert with `assert_no_errors` because
      # the `handlebars` lexer doesn't support arguments like `@name`
      assert_tokens_includes code,
        ["Name.Tag", "<"], ["Keyword", "template"], ["Name.Tag", ">"]
    end
  end
end

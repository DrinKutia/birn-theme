require 'spec_helper'

RSpec.describe 'admin_request/hidden_user_explanation.text.erb' do
  let(:stub_locals) do
    { name_to: 'Bob Smith',
      info_request: double(title: 'Foo'),
      info_request_url: 'https://test.host/request/foo',
      message: 'vexatious',
      site_name: 'Alaveteli' }
  end

  it 'interpolates the locals' do
    render template: self.class.description,
           locals: stub_locals
    expect(rendered).to eq(read_described_template_fixture)
  end

  it 'renders the correct message partial' do
    render template: self.class.description,
           locals: stub_locals.merge(message: 'not_foi')
    expected = 'admin_request/hidden_user_explanation/_not_foi'
    expect(rendered).to render_template(partial: expected)
  end
end

require 'spec_helper'

describe Gast::Repository do
  let(:repo) { Gast::Repository.new }
  let(:git) { Git.init(repo.path) }
  let(:user_content) { 'Hello World' }
  let(:selected_language) { 'ruby' }

  before(:each) do
    repo.content = user_content
    repo.language = selected_language
    repo.create
    repo.write
    repo.commit!
  end

  after(:each) { cleanup_in_the_dir }

  it 'should be create of repository' do
    expect(FileTest.exists?(repo.path)).to be_truthy
  end

  it 'should be content is a Hello world' do
    expect(latest_content).to eq user_content
  end

  it 'should be language is a ruby' do
    expect(latest_language_of_content).to eq selected_language
  end

  it 'should be save of commit message is correct' do
    Timecop.freeze
    expect(git.log.first.message).to eq "commit: #{DateTime.now}"
    Timecop.return
  end
end

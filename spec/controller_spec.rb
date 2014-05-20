require 'spec_helper'

def app
  Gast::App
end

describe Gast::App do

  let(:repo_dir) { File.expand_path("/tmp/gast") }

  after(:each) do
    FileUtils.rm_r(Dir.glob(repo_dir + '/**'), secure: true)
  end

  let(:hello_world) { "Hello World" }
  let(:welcome_to_underground) { "Welcome to underground" }
  let(:view_path) { /.+\/posts\/view\/[a-z0-9]+/ }

  it "should be get index" do
    get '/' 
    expect(last_response).to be_ok
  end
  
  it "should be get title of index" do
    get '/'
    expect(last_response.body).to match(/Gast/)
  end

  it "should be get error" do
    get '/hogehoge'
    expect(last_response).not_to be_ok
  end

  it "should be get list" do
    get '/posts/list'
    expect(last_response).to be_ok
  end

  it "should be save of content on git directory" do
    post '/posts/new', { content: hello_world }
    expect(last_response.status).to eq 302
    expect(last_response.location).to match(view_path)
  end

  it "should be update content" do
    post '/posts/new', { content: hello_world }
    
    expect(last_response.status).to eq 302
    expect(last_response.location).to match(view_path)

    post '/posts/new', { content: welcome_to_underground }
    expect(last_response.status).to eq 302
    expect(last_response.location).to match(view_path)
  end

  it "should be view of item" do
    post '/posts/new', { content: hello_world }

    repository = File.expand_path(Dir.glob(repo_dir + '/**').first)

    get "/posts/view/#{repository.split('/').last}"

    expect(last_response).to be_ok
    expect(File.read(repository + '/content')).to eq hello_world
  end

  it "should be can update of item" do
    post '/posts/new', { content: hello_world }

    repository = File.expand_path(Dir.glob(repo_dir + '/**').first)

    get "/posts/view/#{repository.split('/').last}"

    expect(last_response).to be_ok

    put "/posts/update/#{repository.split('/').last}", { content: welcome_to_underground }
    get "/posts/view/#{repository.split('/').last}"

    expect(last_response).to be_ok

    expect(File.read(repository + '/content')).to eq welcome_to_underground
  end

end
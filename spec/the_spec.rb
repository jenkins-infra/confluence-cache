require 'spec_helper'

def cache(path)
  command("curl --silent --fail #{URL}#{path}")
end

def backend(path)
  command("curl --silent --fail #{BACKEND}#{path}")
end

describe "Confluence Cache" do
  it "should be listening on #{PORT}" do
    expect(port(PORT)).to be_listening
  end

  it "should find pre-generated cache in /cache without hitting backend" do
    expect(cache(  "/display/hello").stdout).to match /Hit confluence-cache/
    expect(backend("/display/hello").exit_status).not_to eq 0
  end

  it "should pass through most of the access" do
    File.write("build/wwwroot/sanfrancisco.html", "Golden Gate Bridge!")
    expect(cache("/sanfrancisco.html").stdout).to match /Golden Gate Bridge!/
    File.write("build/wwwroot/sanfrancisco.html", "Bay Bridge!")
    expect(cache("/sanfrancisco.html").stdout).to match /Bay Bridge!/
  end

  it "should cache /s/... files" do
    File.write("build/wwwroot/s/tokyo.html", "Asakusa!")
    expect(cache("/s/tokyo.html").stdout).to match /Asakusa!/
    File.write("build/wwwroot/s/tokyo.html", "Shinjuku!")
    expect(cache("/s/tokyo.html").stdout).to match /Asakusa!/   # should still be old stale one
  end
end



#describe command("curl #{URL}/sanfrancisco.html") do
#  its(:stdout) { should match 'Golden Gate Bridge!' }
#end

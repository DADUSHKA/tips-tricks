require 'json'

def api
  @api ||= Prismic.api('https://tips-tricks.prismic.io/api')
end

def link_resolver
  maybe_ref = api.master_ref.ref
  @link_resolver ||= Prismic::LinkResolver.new(maybe_ref) do |doc|
    "#{doc.id}"
  end
end

set :server, :puma
set :haml, layout: true

get '/' do
  @tips = api.form('everything').submit(api.master_ref.ref)
  haml :index
end

get '/:id' do
  @tip = api.form("everything").query("[[:d = at(document.id, \"#{params[:id]}\")]]").submit(api.master_ref.ref).first
  haml :show
end

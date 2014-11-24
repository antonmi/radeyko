require 'data_mapper'

DataMapper.setup(:default, { adapter:  'yaml', path: "#{RadeykoApp.root}/db" })
class TestModel

  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :title,      String    # A varchar type string, for short strings
  property :body,       Text

end

DataMapper.finalize
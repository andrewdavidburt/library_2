class Patron

  attr_reader(:name, :id)

  define_method(:initalize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_patron = DB.exec('SELECT * FROM patron;')
    patron = []
    returned_patron.each() do |item|
      name = item.fetch('name')
      id = item.fetch('id').to_i()
      patron.push(Author.new({:name => name, :id => id}))
    end
    patron
  end

  define_singleton_method(:find) do |id|
    @id = id
    result = DB.exec('SELECT * FROM patron WHERE id = #{@id};')
    @name = result.first().fetch('name')
    Author.new({:name => @name, :id => @id})
  end

  define_method(:save) do
    result = DB.exec('INSERT INTO patron (NAME) VALUES ("#{@name}") RETURNING id;')
    @id = result.first().fetch('id').to_i()
  end

  define_method(:==) do |an_item|
    self.name().==(an_item.name()).&(self.id().==(an_item.id()))
  end

  define_method(:change_name) do |attributes|
    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE patron SET name = '#{@name}' WHERE id = #{@id};")
  end

  define_method(:delete) do
    DB.exec("DELETE FROM patron WHERE id = #{self.id()};")
  end

  define_method(:checkouts) do
  end

end

require_relative '../sql_generator'

describe SQLGenerator do
  
  before do
    @table = 'test'
    @values = {'a' => true,'b' => "some string"}
  end

  it "should format a value for sql" do
    SQLGenerator.format_value('string').should eq "\'string\'"
    SQLGenerator.format_value(true).should eq 1
    SQLGenerator.format_value(false).should eq 0
    SQLGenerator.format_value(1).should eq 1
  end

  it "should return a SELECT string" do
    columns = ['a','b','c']
    SQLGenerator.select(@table,columns,@values).should eq "SELECT a, b, c FROM test WHERE a=1 AND b=\'some string\'"
    SQLGenerator.select(@table,columns,nil).should eq "SELECT a, b, c FROM test"
    SQLGenerator.select(@table,nil,nil).should eq "SELECT * FROM test"
  end

  it "should return an INSERT INTO string" do
    SQLGenerator.insert(@table,@values).should eq "INSERT INTO test (a,b) VALUES (1,\'some string\')"
    expect{SQLGenerator.insert(@table,nil)}.to raise_error
    expect{SQLGenerator.insert(nil,nil)}.to raise_error
  end

  it "should return an UPDATE string" do
    conditions = {'a' => 1, 'b'=>'Some other string'}
    SQLGenerator.update(@table,@values,conditions).should eq "UPDATE test SET a=1, b=\'some string\' WHERE a=1 AND b=\'Some other string\'"
    SQLGenerator.update(@table,@values,nil).should eq "UPDATE test SET a=1, b=\'some string\'"
    expect{SQLGenerator.update(@table,nil,nil)}.to raise_error
  end

  it "should return a DELETE string" do
    SQLGenerator.delete(@table,@values).should eq "DELETE FROM test WHERE a=1 AND b=\'some string\'"
    expect{SQLGenerator.delete(@table,nil)}.to raise_error
    expect{SQLGenerator.delete(nil,nil)}.to raise_error
  end
end
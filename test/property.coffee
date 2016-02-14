Property = require '../src/property'
{ assert } = require 'chai'

describe 'property test', ->

  it 'should get correct val', ->
    process.env.INT = '12345'
    prop = Property('INT', 'int')
    assert.equal 12345, prop.parse()

  it 'should work with default', ->
    prop = Property('NON_EXISTENT', 'float', 2345.7)
    assert.equal 2345.7, prop.parse()

  it 'should get normal name', ->
    assert.equal 'FOO', Property.normalName('FOO')
    assert.equal 'FOO', Property.normalName('FOO', undefined)
    assert.equal 'FOO', Property.normalName('FOO', 'MYAPP')
    assert.equal 'FOO', Property.normalName('MYAPP_FOO', 'MYAPP')
  
  it 'should get wrapped name', ->
    assert.equal 'FOO', Property.wrappedName('FOO')
    assert.equal 'FOO', Property.wrappedName('FOO', undefined)
    assert.equal 'MYAPP_FOO', Property.wrappedName('FOO', 'MYAPP')
    assert.equal 'MYAPP_FOO', Property.wrappedName('MYAPP_FOO', 'MYAPP')


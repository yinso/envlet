Builder = require '../src/builder'
{ assert } = require 'chai'

describe 'builder test', ->
  builder = null
  it 'should set', ->
    process.env.ON_ERROR_HALT = 'false'
    process.env.INT = '12345'
    process.env.FLOAT = '1234978.03'
    process.env.MYAPP_STR = 'this is a string'
    builder = Builder('MYAPP')
      .set('MYAPP_INT', { type: 'int' })
      .set('FLOAT', { type: 'float' })
      .set('STR', { type: 'string' })
      .set('MYAPP_BOOL', { type: 'boolean', default: true })
      .alias('BOOL', 'STUFF')
      .parse()

  it 'should get INT', ->
    assert.equal 12345, builder.get('INT')
    assert.equal 12345, builder.get('MYAPP_INT')

  it 'should get FLOAT', ->
    assert.equal 1234978.03, builder.get('FLOAT')
    assert.equal 1234978.03, builder.get('MYAPP_FLOAT')

  it 'should get STR', ->
    assert.equal 'this is a string', builder.get('MYAPP_STR')
    assert.equal 'this is a string', builder.get('STR')
  
  it 'should get BOOL', ->
    assert.equal true, builder.get('BOOL')
    assert.equal true, builder.get('MYAPP_BOOL')

  it 'alias should work', -> 
    assert.equal true, builder.get('STUFF')
    assert.equal true, builder.get('MYAPP_STUFF')


# Envlet - Environment variable parsing

Envlet handles and parses environment variables, similar to `optimist` for command line arguments. It has the following features:

* Handle application prefixes seamlessly.

  I.e. if you have a `FOO` environment variable, you can either call it `MYAPP_FOO`, or just `FOO`.
  
* Manages JavaScript primitive types as well as array types.

  This is done via [`typelet`](https://www.npmjs.com/package/typelet)'s parsing, so you can specify types like:

    * `int`
    * `float`
    * `bool`
    * `string`
    * `date`
    * `[ int ]` (array of integer)

* Prints usages on error. Like `optimist`, you can build up the parsing spec, and on error, the spec will be printed and program halted.

## Install

    npm install envlet

## Usage

    var getenv = require('envlet')
      .app('myapp')
      .set('FOO', {
        type: 'int',
        default: 50 // default value must match type.
      })
      .set('BAR', {
        type: 'float'
      })
      .set('BAZ', {
        type: '[ int ]', // array of integer - see typelet
      })
      .alias('BAZ', 'XYZ') // XYZ is aliased to BAZ.
      .parse(); // errors out and print usage if the above aren't satisfied.
   
    getenv.get('FOO'); // ==> process.env.FOO, process.env.MYAPP_FOO or 50
    getenv.get('BAR'); // ==> process.env.BAR, process.env.MYAPP_BAR // error if neither exists.
    getenv.get('BAZ'); // ==> besides BAZ and MYAPP_BAZ, since XYZ is aliased to BAZ, XYZ and MYAPP_XYZ also responds.

    getenv.usage(); // prints the following.
    // myapp usage:
    //   FOO|MYAPP_FOO:
    //     type: integer, default: 50
    //   BAR|MYAPP_BAR:
    //     type: float, required: true
    //   BAZ|MYAPP_BAZ|XYZ|MYAPP_XYZ:
    //     type: [ int ]

    


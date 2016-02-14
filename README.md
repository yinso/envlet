# Envlet - Environment variable parsing


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

    


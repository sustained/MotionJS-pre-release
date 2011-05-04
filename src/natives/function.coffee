Function.isFunction = (object) -> toString.call(object) is '[object Function]'

Function.isConstructor = (object) -> Function.isFunction(object) and object.constructor?
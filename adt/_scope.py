
from _hashmap import HashMap
from _ref     import Ref
from _ftypes  import mappedType, CALLBACK
from ctypes   import byref, c_char_p, c_int, POINTER


_cbITF_buffer = dict()

@mappedType( 'hashmap', 'type(HashMap_t)' )
class Scope(HashMap):

  class Index(HashMap.Index):

    def get( self ):
      key, valRef = super(type(self), self).get()
      try   : return (key, valRef.typed.contents)
      except: return (key, valRef.typed)


  def __getitem__( self, ident ):
    valRef = super(Scope, self).__getitem__( ident ).typed
    try   : return valRef.contents
    except: return valRef


  def __setitem__( self, ident, val ):
    item   = self._getptr( self.get_, ident ).contents
    valRef = item.typed #< valRef := c_###() | Ref() | None [for NEW Items]
    valRef = getattr( valRef, 'contents', valRef ) or item
    # valRef := c_###() [for Ref() | c_###()] | Item()
    try             : valRef[:]    = val[:]
    except TypeError: valRef.value = getattr( val, 'value', val )


  def setCallback( self, ident, cbFunc ):
    if type(type(cbFunc)) is not type(CALLBACK):
      _cbITF_buffer['{0}.{1}'.format(id(self), ident)] = func = CALLBACK(cbFunc or 0)
    return self.set_callback_( byref(self), c_char_p(ident), func, c_int(len(ident)) )


  @classmethod
  def getProcessScope( _class ):
    ptr = POINTER(_class)()
    _class.__getattr__('get_processscope_')( byref(ptr) )
    return ptr.contents

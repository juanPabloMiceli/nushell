@0xb299d30dc02d72bc;
# Schema representing all the structs that are used to comunicate with
# the plugins.
# This schema, together with the command capnp proto is used to generate
# the rust file that defines the serialization/deserialization objects
# required to comunicate with the plugins created for nushell

# Generic structs used as helpers for the encoding
struct Option(Value) {
	union {
		none @0 :Void;
		some @1 :Value;
	}
}

struct Map(Key, Value) {
  struct Entry {
    key @0 :Key;
    value @1 :Value;
  }
  entries @0 :List(Entry);
}

# Main plugin structures
struct Span {
	start @0 :UInt64;
	end @1 :UInt64;
}

struct Value {
	span @0: Span;

	union {
		void @1 :Void;
		bool @2 :Bool;
		int @3 :Int64;
		float @4 :Float64;
		string @5 :Text;
		list @6 :List(Value);
	}
}

struct Signature {
    name @0 :Text;
    usage @1 :Text;
    extraUsage @2 :Text;
    requiredPositional @3 :List(Argument);
    optionalPositional @4 :List(Argument);
    rest @5 :Option(Argument);
    named @6 :List(Flag);
    isFilter @7 :Bool;
}

struct Flag {
    long @0 :Text;
    short @1 :Option(Text);
    arg @2 :Shape;
    required @3 :Bool;
    desc @4 :Text;
}

struct Argument {
    name @0 :Text;
    desc @1 :Text;
    shape @2 :Shape;
}

# If we require more complex signatures for the plugins this could be
# changed to a union
enum Shape {
	none @0;
	any @1;
	string @2;
	number @3;
	int @4;
	boolean @5;
}

struct Expression {
	union {
		garbage @0 :Void;
		bool @1 :Bool;
		int @2 :Int64;
		float @3 :Float64;
		string @4 :Text;
		list @5 :List(Expression);
		# The expression list can be exteded based on the user need
		# If a plugin requires something from the expression object, it
		# will need to be added to this list
	}
}

struct Call {
	head @0: Span;
	positional @1 :List(Expression);
	named @2 :Map(Text, Option(Expression));
}

struct CallInfo {
	call @0: Call;
	input @1: Value;
}

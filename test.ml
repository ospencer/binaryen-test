open Binaryen

let wasm_mod = Module.create ()

(* Create function type for i32 (i32, i32) *)
let params = Type.create [| Type.int32; Type.int32 |]

let results = Type.int32

let x () = Expression.local_get wasm_mod 0 Type.int32

let y () = Expression.local_get wasm_mod 1 Type.int32

let add = Expression.if_ wasm_mod (Expression.unary wasm_mod Op.eq_z_int32 (x())) (Expression.unreachable wasm_mod) (Expression.binary wasm_mod Op.add_int32 (x()) (y()))

(* Create the add function *)
let adder = Function.add_function wasm_mod "adder" params results [||] add

let _ = Export.add_function_export wasm_mod "adder" "adder"

let _ = Module.print wasm_mod

let _ = Module.optimize wasm_mod

let _ = Module.print wasm_mod

let _ = Module.dispose wasm_mod

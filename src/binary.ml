open Binaryen

let run () =

  let wasm_mod = Module.create () in

  (* Create function type for i32 (i32, i32) *)
  let params = Type.create [| Type.int32; Type.int32 |] in

  let results = Type.int32 in

  let x () = Expression.local_get wasm_mod 0 Type.int32 in

  let y () = Expression.local_get wasm_mod 1 Type.int32 in

  let add = Expression.if_ wasm_mod (Expression.unary wasm_mod Op.eq_z_int32 (x())) (Expression.unreachable wasm_mod) (Expression.binary wasm_mod Op.add_int32 (x()) (y())) in

  (* Create the add function *)
  let func = Function.add_function wasm_mod "adder" params results [||] add in

  let _ = Export.add_function_export wasm_mod "adder" "adder" in
  let _ = Printf.eprintf "eq: %b\n" ((Import.function_import_get_module func) = "") in

  Module.dispose wasm_mod

(* generated by Ott 0.32, locally-nameless lngen from: Lambda.ott *)
Require Import Metalib.Metatheory.
(** syntax *)
Definition expvar : Set := var.

Inductive exp : Set := 
 | var_b (_:nat)
 | var_f (x:expvar)
 | app (e1:exp) (e2:exp)
 | abs (e:exp).

(* EXPERIMENTAL *)
(** auxiliary functions on the new list types *)
(** library functions *)
(** subrules *)
Definition is_value_of_exp (e_5:exp) : Prop :=
  match e_5 with
  | (var_b nat) => False
  | (var_f x) => False
  | (app e1 e2) => False
  | (abs e) => (True)
end.

(** arities *)
(** opening up abstractions *)
Fixpoint open_exp_wrt_exp_rec (k:nat) (e_5:exp) (e__6:exp) {struct e__6}: exp :=
  match e__6 with
  | (var_b nat) => 
      match lt_eq_lt_dec nat k with
        | inleft (left _) => var_b nat
        | inleft (right _) => e_5
        | inright _ => var_b (nat - 1)
      end
  | (var_f x) => var_f x
  | (app e1 e2) => app (open_exp_wrt_exp_rec k e_5 e1) (open_exp_wrt_exp_rec k e_5 e2)
  | (abs e) => abs (open_exp_wrt_exp_rec (S k) e_5 e)
end.

Definition open_exp_wrt_exp e_5 e__6 := open_exp_wrt_exp_rec 0 e__6 e_5.

(** closing up abstractions *)
Fixpoint close_exp_wrt_exp_rec (k:nat) (e_5:var) (e__6:exp) {struct e__6}: exp :=
  match e__6 with
  | (var_b nat) => 
       if (lt_dec nat k) 
         then var_b nat
         else var_b (S nat)
  | (var_f x) => if (e_5 === x) then (var_b k) else (var_f x)
  | (app e1 e2) => app (close_exp_wrt_exp_rec k e_5 e1) (close_exp_wrt_exp_rec k e_5 e2)
  | (abs e) => abs (close_exp_wrt_exp_rec (S k) e_5 e)
end.

Definition close_exp_wrt_exp e__6 e_5 := close_exp_wrt_exp_rec 0 e__6 e_5.

(** terms are locally-closed pre-terms *)
(** definitions *)

(* defns LC_exp *)
Inductive lc_exp : exp -> Prop :=    (* defn lc_exp *)
 | lc_var_f : forall (x:expvar),
     (lc_exp (var_f x))
 | lc_app : forall (e1 e2:exp),
     (lc_exp e1) ->
     (lc_exp e2) ->
     (lc_exp (app e1 e2))
 | lc_abs : forall (e:exp),
      ( forall x , lc_exp  ( open_exp_wrt_exp e (var_f x) )  )  ->
     (lc_exp (abs e)).
(** free variables *)
Fixpoint fv_exp (e_5:exp) : vars :=
  match e_5 with
  | (var_b nat) => {}
  | (var_f x) => {{x}}
  | (app e1 e2) => (fv_exp e1) \u (fv_exp e2)
  | (abs e) => (fv_exp e)
end.

(** substitutions *)
Fixpoint subst_exp (e_5:exp) (x5:expvar) (e__6:exp) {struct e__6} : exp :=
  match e__6 with
  | (var_b nat) => var_b nat
  | (var_f x) => (if eq_var x x5 then e_5 else (var_f x))
  | (app e1 e2) => app (subst_exp e_5 x5 e1) (subst_exp e_5 x5 e2)
  | (abs e) => abs (subst_exp e_5 x5 e)
end.


(** definitions *)

(* defns Jop *)
Inductive reduce : exp -> exp -> Prop :=    (* defn reduce *)
 | red_beta : forall (e1 e2:exp),
     lc_exp (abs e1) ->
     lc_exp e2 ->
     reduce (app  ( (abs e1) )  e2)  (open_exp_wrt_exp  e1   e2 ) 
 | red_app_fun : forall (e1 e2 e1':exp),
     lc_exp e2 ->
     reduce e1 e1' ->
     reduce (app e1 e2) (app e1' e2)
 | red_app_arg : forall (e2 e2' v1:exp),
     is_value_of_exp v1 ->
     lc_exp v1 ->
     reduce e2 e2' ->
     reduce (app v1 e2) (app v1 e2').


(** infrastructure *)
#[export] Hint Constructors reduce lc_exp : core.



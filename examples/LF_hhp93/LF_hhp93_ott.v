(* generated by Ott 0.32, locally-nameless lngen from: LF_hhp93.ott *)
Require Import Metalib.Metatheory.
(** syntax *)
Definition family_constant : Set := atom.
Definition object_constant : Set := atom.

Inductive family : Set := 
 | family_const (a:family_constant)
 | family_pi (A:family) (B:family)
 | family_abs (A:family) (B:family)
 | family_app (A:family) (M:object)
with object : Set := 
 | object_const (c:object_constant)
 | object_var_b (_:nat)
 | object_var_f (x:var)
 | object_abs (A:family) (M:object)
 | object_app (M:object) (N:object).

Inductive kind : Set := 
 | kind_type : kind
 | kind_pi (A:family) (K:kind).

(* EXPERIMENTAL *)
(** auxiliary functions on the new list types *)
(** library functions *)
(** subrules *)
(** arities *)
(** opening up abstractions *)
Fixpoint open_object_wrt_object_rec (k:nat) (M5:object) (M_6:object) {struct M_6}: object :=
  match M_6 with
  | (object_const c) => object_const c
  | (object_var_b nat) => 
      match lt_eq_lt_dec nat k with
        | inleft (left _) => object_var_b nat
        | inleft (right _) => M5
        | inright _ => object_var_b (nat - 1)
      end
  | (object_var_f x) => object_var_f x
  | (object_abs A M) => object_abs (open_family_wrt_object_rec k M5 A) (open_object_wrt_object_rec (S k) M5 M)
  | (object_app M N) => object_app (open_object_wrt_object_rec k M5 M) (open_object_wrt_object_rec k M5 N)
end
with open_family_wrt_object_rec (k:nat) (M5:object) (A5:family) {struct A5}: family :=
  match A5 with
  | (family_const a) => family_const a
  | (family_pi A B) => family_pi (open_family_wrt_object_rec k M5 A) (open_family_wrt_object_rec (S k) M5 B)
  | (family_abs A B) => family_abs (open_family_wrt_object_rec k M5 A) (open_family_wrt_object_rec (S k) M5 B)
  | (family_app A M) => family_app (open_family_wrt_object_rec k M5 A) (open_object_wrt_object_rec k M5 M)
end.

Fixpoint open_kind_wrt_object_rec (k:nat) (M5:object) (K5:kind) {struct K5}: kind :=
  match K5 with
  | kind_type => kind_type 
  | (kind_pi A K) => kind_pi (open_family_wrt_object_rec k M5 A) (open_kind_wrt_object_rec (S k) M5 K)
end.

Definition open_kind_wrt_object M5 K5 := open_kind_wrt_object_rec 0 K5 M5.

Definition open_family_wrt_object M5 A5 := open_family_wrt_object_rec 0 A5 M5.

Definition open_object_wrt_object M5 M_6 := open_object_wrt_object_rec 0 M_6 M5.

(** closing up abstractions *)
Fixpoint close_object_wrt_object_rec (k:nat) (M5:var) (M_6:object) {struct M_6}: object :=
  match M_6 with
  | (object_const c) => object_const c
  | (object_var_b nat) => 
       if (lt_dec nat k) 
         then object_var_b nat
         else object_var_b (S nat)
  | (object_var_f x) => if (M5 === x) then (object_var_b k) else (object_var_f x)
  | (object_abs A M) => object_abs (close_family_wrt_object_rec k M5 A) (close_object_wrt_object_rec (S k) M5 M)
  | (object_app M N) => object_app (close_object_wrt_object_rec k M5 M) (close_object_wrt_object_rec k M5 N)
end
with close_family_wrt_object_rec (k:nat) (M5:var) (A5:family) {struct A5}: family :=
  match A5 with
  | (family_const a) => family_const a
  | (family_pi A B) => family_pi (close_family_wrt_object_rec k M5 A) (close_family_wrt_object_rec (S k) M5 B)
  | (family_abs A B) => family_abs (close_family_wrt_object_rec k M5 A) (close_family_wrt_object_rec (S k) M5 B)
  | (family_app A M) => family_app (close_family_wrt_object_rec k M5 A) (close_object_wrt_object_rec k M5 M)
end.

Fixpoint close_kind_wrt_object_rec (k:nat) (M5:var) (K5:kind) {struct K5}: kind :=
  match K5 with
  | kind_type => kind_type 
  | (kind_pi A K) => kind_pi (close_family_wrt_object_rec k M5 A) (close_kind_wrt_object_rec (S k) M5 K)
end.

Definition close_kind_wrt_object K5 M5 := close_kind_wrt_object_rec 0 K5 M5.

Definition close_family_wrt_object A5 M5 := close_family_wrt_object_rec 0 A5 M5.

Definition close_object_wrt_object M_6 M5 := close_object_wrt_object_rec 0 M_6 M5.

(** terms are locally-closed pre-terms *)
(** definitions *)

(* defns LC_object_family *)
Inductive lc_object : object -> Prop :=    (* defn lc_object *)
 | lc_object_const : forall (c:object_constant),
     (lc_object (object_const c))
 | lc_object_var_f : forall (x:var),
     (lc_object (object_var_f x))
 | lc_object_abs : forall (A:family) (M:object),
     (lc_family A) ->
      ( forall x , lc_object  ( open_object_wrt_object M (object_var_f x) )  )  ->
     (lc_object (object_abs A M))
 | lc_object_app : forall (M N:object),
     (lc_object M) ->
     (lc_object N) ->
     (lc_object (object_app M N))
with lc_family : family -> Prop :=    (* defn lc_family *)
 | lc_family_const : forall (a:family_constant),
     (lc_family (family_const a))
 | lc_family_pi : forall (A B:family),
     (lc_family A) ->
      ( forall x , lc_family  ( open_family_wrt_object B (object_var_f x) )  )  ->
     (lc_family (family_pi A B))
 | lc_family_abs : forall (A B:family),
     (lc_family A) ->
      ( forall x , lc_family  ( open_family_wrt_object B (object_var_f x) )  )  ->
     (lc_family (family_abs A B))
 | lc_family_app : forall (A:family) (M:object),
     (lc_family A) ->
     (lc_object M) ->
     (lc_family (family_app A M)).

(* defns LC_kind *)
Inductive lc_kind : kind -> Prop :=    (* defn lc_kind *)
 | lc_kind_type : 
     (lc_kind kind_type)
 | lc_kind_pi : forall (A:family) (K:kind),
     (lc_family A) ->
      ( forall x , lc_kind  ( open_kind_wrt_object K (object_var_f x) )  )  ->
     (lc_kind (kind_pi A K)).
(** free variables *)
Fixpoint fv_object (M5:object) : vars :=
  match M5 with
  | (object_const c) => {}
  | (object_var_b nat) => {}
  | (object_var_f x) => {{x}}
  | (object_abs A M) => (fv_family A) \u (fv_object M)
  | (object_app M N) => (fv_object M) \u (fv_object N)
end
with fv_family (A5:family) : vars :=
  match A5 with
  | (family_const a) => {}
  | (family_pi A B) => (fv_family A) \u (fv_family B)
  | (family_abs A B) => (fv_family A) \u (fv_family B)
  | (family_app A M) => (fv_family A) \u (fv_object M)
end.

Fixpoint fv_kind (K5:kind) : vars :=
  match K5 with
  | kind_type => {}
  | (kind_pi A K) => (fv_family A) \u (fv_kind K)
end.

(** substitutions *)
Fixpoint subst_object (M5:object) (x5:var) (M_6:object) {struct M_6} : object :=
  match M_6 with
  | (object_const c) => object_const c
  | (object_var_b nat) => object_var_b nat
  | (object_var_f x) => (if eq_var x x5 then M5 else (object_var_f x))
  | (object_abs A M) => object_abs (subst_family M5 x5 A) (subst_object M5 x5 M)
  | (object_app M N) => object_app (subst_object M5 x5 M) (subst_object M5 x5 N)
end
with subst_family (M5:object) (x5:var) (A5:family) {struct A5} : family :=
  match A5 with
  | (family_const a) => family_const a
  | (family_pi A B) => family_pi (subst_family M5 x5 A) (subst_family M5 x5 B)
  | (family_abs A B) => family_abs (subst_family M5 x5 A) (subst_family M5 x5 B)
  | (family_app A M) => family_app (subst_family M5 x5 A) (subst_object M5 x5 M)
end.

Fixpoint subst_kind (M5:object) (x5:var) (K5:kind) {struct K5} : kind :=
  match K5 with
  | kind_type => kind_type 
  | (kind_pi A K) => kind_pi (subst_family M5 x5 A) (subst_kind M5 x5 K)
end.


(** definitions *)


(** infrastructure *)
#[export] Hint Constructors lc_object lc_family lc_kind : core.



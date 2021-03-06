(* Written by Stephen Weeks (sweeks@acm.org). *)

structure Main =
   struct
      fun doit () =
	 let
	    open TextIO
	    val f = OS.FileSys.tmpName ()
	    val out = openOut f
	    val _ =
	       output (out,
		       String.implode
		       (List.tabulate (1000000, fn i =>
				       if i mod 10 = 0 then #"\n" else #"a")))
	    val _ = closeOut out
	    fun wc f =
	       let
		  val ins = openIn f
	       in TextIO.scanStream
		  (fn reader => fn s =>
		   let
		      fun loop (s, ns) =
			 case reader s of
			    NONE => (closeIn ins
				     ; print (concat [Int.toString ns,
						    " newlines\n"])
				     ; NONE)
			  | SOME (c, s') =>
			       loop (s', if c = #"\n" then ns + 1 else ns)
		   in loop (s, 0)
		   end)
		  ins
	       end
	    val rec loop =
	       fn 0 => ()
		| n => (wc f; loop (n - 1))
	    val _ = loop 20
	    val _ = OS.FileSys.remove f
	 in ()
	 end
   end

fun doit() = Main.doit()
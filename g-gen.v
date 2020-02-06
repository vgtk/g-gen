module main

import vgobject.gi
import os
import strings

fn gen_cdefs(namespace string, repo &gi.Repository) string {
	mut builder := strings.new_builder(1024)
	n_info := repo.get_n_infos(namespace)
	for i := 0; i < n_info; i++ {
		bi := repo.get_info(namespace, i)
		typ := bi.get_type()
		if (typ == gi.INFO_TYPE_OBJECT) {
			oi := gi.to_object_info(bi)
			builder.write(object_cdefs(oi))
		}
	}
	return builder.str()
}

fn object_cdefs(info &gi.ObjectInfo) string {
	mut builder := strings.new_builder(1024)
	builder.writeln("/// " + info.get_type_name() + " ///")
	n_methods := info.get_n_methods()
	for j := 0; j < n_methods; j++ {
		fi := info.get_method(j)
		mut fdef := "fn " + fi.get_symbol() + "("
		// TODO: Get property info of this method
		fdef += ")"
		builder.writeln(fdef)
	}
	return builder.str()
}

fn main() {
	namespace := "Gtk"
	repo := gi.get_default_repository()
	repo.require(namespace, "") or { panic(err) }
	repo.require("GLib", "") or { panic(err) }
	repo.require("Gdk", "") or { panic(err) }
	repo.require("Pango", "") or { panic(err) }

	if !os.exists('out') {
		os.mkdir("out") or { panic(err) }
	}

	cdefs := gen_cdefs(namespace, repo)
	println(cdefs)
}

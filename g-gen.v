import vgobject.gi
import os
import strings

fn gen_cdefs(namespace string, repo &gi.Repository) string {
	mut builder := strings.new_builder(1024)
	for i := 0; i < info_count; i++ {
		bi := repo.get_info(namespace, i)
		name := bi.get_name()
		typ := bi.get_type()
		type_str := typ.str()
		if (typ == gi.INFO_TYPE_OBJECT) {
			oi := bi.to_object_info()
			builder.write(object_cdefs(oi))
		}
	}
	return builder.str()
}

fn object_cdefs(info &gi.ObjectInfo) string {
	mut builder := strings.new_builder(1024)
	builder.writeln("/// " + info.get_type_name() + " ///")
	method_count := info.get_n_methods()
	for j := 0; j < method_count; j++ {
		fi := info.get_method(j)
		fbi := &gi.BaseInfo(fi)
		fdef := "fn " + info.get_type_init() + "_" + fbi.get_name() + "(...)"
		builder.writeln(fdef)
	}
	return builder.str()
}

fn main() {
	namespace := "Gtk"
	repo := gi.get_default_repository()
	repo.require(namespace, "") or {
		eprintln("could not find '" + namespace + "' typelib: " + err)
		exit(1)
	}
	os.mkdir("out")
	info_count := repo.get_n_infos(namespace)

	println(gen_cdefs(namespace, repo))
}

import vgobject.gi
/*
fn gen_cdefs(namespace string, repo &gi.Repository) {
	str := ""
	info_count := repo.get_n_infos(namespace)

	for i := 0; i < info_count; i++ {
		bi := repo.get_info(namespace, i)
		name := bi.get_name()
		typ := bi.get_type()
		type_str := typ.str()
		println(name)
		if (typ == gi.INFO_TYPE_OBJECT) {
			object := bi.to_object_info()
		}
	}
}
*/

fn object_cdefs(info &gi.ObjectInfo) string {
	mut str := ""
	str = str + "/// " + info.get_type_name() + " ///\n"
	method_count := info.get_n_methods()
	for j := 0; j < method_count; j++ {
		fi := info.get_method(j)
		fbi := &gi.BaseInfo(fi)
		fdef := "fn " + info.get_type_init() + "_" + fbi.get_name() + "(...)"
		str = str + fdef + "\n"
	}
	return str
}

fn main() {
	namespace := "Gtk"
	repo := gi.get_default_repository()
	repo.require(namespace, "") or {
		eprintln("could not find '" + namespace + "' typelib: " + err)
		exit(1)
	}

	info_count := repo.get_n_infos(namespace)

	for i := 0; i < info_count; i++ {
		bi := repo.get_info(namespace, i)
		name := bi.get_name()
		typ := bi.get_type()
		type_str := typ.str()
		if (typ == gi.INFO_TYPE_OBJECT) {
			oi := bi.to_object_info()
			println(object_cdefs(oi))
		}
	}

	//println(gen_cdefs(namespace, repo))
}

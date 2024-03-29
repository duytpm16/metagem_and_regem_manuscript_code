task run_regem {
	File inputfile
	Int memory
	Int cpu
	Int disk
	Int preemptible
	Int? monitoring_freq = 1
	String exposure_names
	String? int_covar_names
	String output_style

	command {
		dstat -c -d -m --nocolor ${monitoring_freq} > regem_system_resource_usage.log &
		atop -x -P PRM ${monitoring_freq} | grep '(REGEM)' > regem_process_resource_usage.log &

		/REGEM/REGEM \
			--input-file ${inputfile} \
			--exposure-names ${exposure_names} \
			${"--int-covar-names " + int_covar_names} \
			--output-style ${output_style} \
			--out regem_results
	}

	runtime {
		docker: "dx://project-FyJ05zQ06y16kP7b5vQZXZvP:file-GV4VGP806y194JgJVB9jG389"
		memory: "${memory} GB"
		cpu: "${cpu}"
		disks: "local-disk ${disk} HDD"
		preemptible: "${preemptible}"
		gpu: false
		dx_timeout: "7D0H00M"
	}

	output {
		File out = "regem_results"
		File system_resource_usage = "regem_system_resource_usage.log"
		File process_resource_usage = "regem_process_resource_usage.log"
	}
}


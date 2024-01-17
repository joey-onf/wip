# -*- makefile -*-
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
all += repos/onos
all += repos/voltha

gather-args += --repo voltha-lib-go
gather-args += --patch-sets
# gather-args += --view-query patch-sets 
gather-args += --preserve foo

all : $(all)
	./gather.sh $(gather-args)

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
voltha-release := ../../voltha-release
voltha-release ?= $(voltha-relase path is required)

repos/onos repos/voltha:
	@mkdir -p $(dir $@)
	rsync -rv --checksum "$(voltha-release)/conf/$@" $@

clean ::
	$(RM) $(all)

sterile :: clean
	$(RM) -r preserve

# [EOF]

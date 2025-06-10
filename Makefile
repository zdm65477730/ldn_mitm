APP_TITLE = ldn_mitm
APP_VERSION = v1.16.0
ifeq ($(RELEASE),)
	APP_VERSION	:=	$(APP_VERSION)-$(shell git describe --always)
endif
export APP_TITLE
export APP_VERSION
APP_TITID := $(shell grep -oP '"tid":\s*"\K(\w+)' $(CURDIR)/ldn_mitm/res/toolbox.json)

KIPS := $(APP_TITLE)
NROS := ldnmitm_config

SUBFOLDERS := Atmosphere-libs/libstratosphere $(KIPS) $(NROS) overlay

TOPTARGETS := all clean

OUTDIR		:=	SdOut
SD_ROOT     :=  $(OUTDIR)
NRO_DIR     :=  $(SD_ROOT)/switch/ldnmitm_config
TITLE_DIR   :=  $(SD_ROOT)/atmosphere/contents/$(APP_TITID)
OVERLAY_DIR :=  $(SD_ROOT)/switch/.overlays

all: PACK

$(SUBFOLDERS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

$(KIPS): Atmosphere-libs/libstratosphere

#---------------------------------------------------------------------------------
PACK: $(SUBFOLDERS)
	@ mkdir -p $(NRO_DIR)
	@ mkdir -p $(TITLE_DIR)/flags
	@ mkdir -p $(OVERLAY_DIR)/lang/$(APP_TITLE)
	@ cp ldnmitm_config/$(APP_TITLE).nro $(NRO_DIR)/$(APP_TITLE).nro
	@ cp ldn_mitm/$(APP_TITLE).nsp $(TITLE_DIR)/exefs.nsp
	@ cp overlay/$(APP_TITLE).ovl $(OVERLAY_DIR)/$(APP_TITLE).ovl
	@ cp -rf overlay/lang/* $(OVERLAY_DIR)/lang/$(APP_TITLE)/
	@ cp ldn_mitm/res/toolbox.json $(TITLE_DIR)/toolbox.json
	@ touch $(TITLE_DIR)/flags/boot2.flag
	@cd $(CURDIR)/SdOut; zip -r -q -9 $(APP_TITLE).zip atmosphere switch; cd $(CURDIR)

#---------------------------------------------------------------------------------
clean:
	@ $(MAKE) -C ldn_mitm clean
	@ $(MAKE) -C ldnmitm_config clean
	@ $(MAKE) -C overlay clean
	@ rm -rf $(OUTDIR)

.PHONY: $(TOPTARGETS) $(SUBFOLDERS)

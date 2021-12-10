SHELL:=/bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PREFIX = $(shell cat $(ROOT_DIR)/terraform.tfvars| grep ^prefix | cut -d'"' -f2)
VERSION=$(shell git describe --long --tags)


.PHONY: update-submodules
update-submodules:
	git submodule update --init --recursive

.PHONY: patch-upstream
patch-upstream: dgca-wallet-app-android-patch dgca-app-core-android-patch dgca-verifier-service-patch dgca-verifier-app-android-patch dgca-issuance-web-patch dgca-issuance-service-patch dgca-businessrule-service-patch dgc-gateway-patch dgc-certlogic-android-pat

.PHONY: dgca-wallet-app-android-patch
dgca-wallet-app-android-patch:
	cd $(ROOT_DIR)/dgca-wallet-app-android/; \
	for file in $(ROOT_DIR)/patches/dgca-wallet-app-android/*.patch; do \
		git apply -p1 --verbose < $$file; \
	done;

.PHONY: dgca-app-core-android-patch
dgca-app-core-android-patch:
	cd $(ROOT_DIR)/ dgca-app-core-android/; \
	for file in $(ROOT_DIR)/patches/dgca-app-core-android/*.patch; do \
		git apply -p1 --verbose < $$file; \
	done;

.PHONY: dgca-verifier-service-patch
dgca-verifier-service-patch:
	cd $(ROOT_DIR)/dgca-verifier-service/; \
	for file in $(ROOT_DIR)/patches/dgca-verifier-service/*.patch; do \
		git apply -p1 --verbose < $$file; \
	done;

.PHONY: dgca-verifier-app-android-patch
dgca-verifier-app-android-patch:
	cd $(ROOT_DIR)/dgca-verifier-app-android/; \
	for file in $(ROOT_DIR)/patches/dgca-verifier-app-android/*.patch; do \
		git apply -p1 --verbose < $$file; \
	done;

.PHONY: dgca-issuance-web-patch
dgca-issuance-web-patch:
	cd $(ROOT_DIR)/dgca-issuance-web/; \
	for file in $(ROOT_DIR)/patches/dgca-issuance-web/*.patch; do \
		git apply -p1 --verbose < $$file; \
	done;

.PHONY: dgca-issuance-service-patch
dgca-issuance-service-patch:
	cd $(ROOT_DIR)/dgca-issuance-service/; \
	for file in $(ROOT_DIR)/patches/dgca-issuance-service/*.patch; do \
		git apply -p1 --verbose < $$file; \
	done;

.PHONY: dgca-businessrule-service-patch
dgca-businessrule-service-patch:
	cd $(ROOT_DIR)/dgca-businessrule-service/ &
	for file in $(ROOT_DIR)/patches/dgca-businessrule-service/*.patch; do \
		git apply -p1 --verbose < $$file; \
	done;

.PHONY: dgc-gateway-patch
dgc-gateway-patch:
	cd $(ROOT_DIR)/dgc-gateway/; \
	for file in $(ROOT_DIR)/patches/dgc-gateway/*.patch; do \
		git apply -p1 --verbose < $$file; \
	done;

.PHONY: dgc-certlogic-android-patch
dgc-certlogic-android-patch:
	cd $(ROOT_DIR)/dgc-certlogic-android/; \
	for file in $(ROOT_DIR)/patches/dgc-certlogic-android/*.patch; do \
		git apply -p1 --verbose < $$file; \
	done;

.PHONY: dgca-wallet-app-android-build
dgca-wallet-app-android-build:
	cd $(ROOT_DIR)/dgca-wallet-app-android/; \
	./gradlew --no-daemon build -x test -PCONFIG_FILE_NAME="wallet-context.jsonc" --info

.PHONY: dgca-verifier-app-android-build
dgca-verifier-app-android-build:
	cd $(ROOT_DIR)/dgca-verifier-app-android/; \
	./gradlew --no-daemon build -x test -PCONFIG_FILE_NAME="verifier-context.jsonc" --info

.PHONY: dgca-wallet-app-android-sign
dgca-wallet-app-android-sign:
	zipalign -c -v 4 $(ROOT_DIR)/dgca-wallet-app-android/app/build/outputs/apk/acc/release/app-acc-release-unsigned.apk; \
	java -jar /usr/bin/apksigner sign \
	--ks $(ROOT_DIR)/../certs/dgca-wallet-sign-cert.jks \
	--ks-pass pass:"$${KEY_STORE_PASSWORD}" \
	--ks-key-alias "$${KEY_ALIAS}" \
	--out $(ROOT_DIR)/dgca-wallet-app-android-release-signed.apk \
	$(ROOT_DIR)/dgca-wallet-app-android/app/build/outputs/apk/acc/release/app-acc-release-unsigned.apk; \
    java -jar /usr/bin/apksigner verify $(ROOT_DIR)/dgca-wallet-app-android-release-signed.apk; \
	zipalign -c -v 4 $(ROOT_DIR)/dgca-wallet-app-android/app/build/outputs/apk/acc/debug/app-acc-debug.apk; \
	java -jar /usr/bin/apksigner sign \
	--ks $(ROOT_DIR)/../certs/dgca-wallet-sign-cert.jks \
	--ks-pass pass:"$${KEY_STORE_PASSWORD}" \
	--ks-key-alias "$${KEY_ALIAS}" \
	--out $(ROOT_DIR)/dgca-wallet-app-android-debug-signed.apk \
	$(ROOT_DIR)/dgca-wallet-app-android/app/build/outputs/apk/acc/debug/app-acc-debug.apk; \
    java -jar /usr/bin/apksigner verify $(ROOT_DIR)/dgca-wallet-app-android-debug-signed.apk

.PHONY: dgca-verifier-app-android-sign
dgca-verifier-app-android-sign:
	zipalign -c -v 4 $(ROOT_DIR)/dgca-verifier-app-android/app/build/outputs/apk/acc/release/app-acc-release-unsigned.apk; \
	java -jar /usr/bin/apksigner sign \
	--ks $(ROOT_DIR)/../certs/dgca-wallet-sign-cert.jks \
	--ks-pass pass:"$${KEY_STORE_PASSWORD}" \
	--ks-key-alias "$${KEY_ALIAS}" \
	--out $(ROOT_DIR)/dgca-verifier-app-android-release-signed.apk \
	$(ROOT_DIR)/dgca-verifier-app-android/app/build/outputs/apk/acc/release/app-acc-release-unsigned.apk; \
    java -jar /usr/bin/apksigner verify $(ROOT_DIR)/dgca-verifier-app-android-release-signed.apk; \
	zipalign -c -v 4 $(ROOT_DIR)/dgca-verifier-app-android/app/build/outputs/apk/acc/debug/app-acc-debug.apk; \
	java -jar /usr/bin/apksigner sign \
	--ks $(ROOT_DIR)/../certs/dgca-wallet-sign-cert.jks \
	--ks-pass pass:"$${KEY_STORE_PASSWORD}" \
	--ks-key-alias "$${KEY_ALIAS}" \
	--out $(ROOT_DIR)/dgca-verifier-app-android-debug-signed.apk \
	$(ROOT_DIR)/dgca-verifier-app-android/app/build/outputs/apk/acc/debug/app-acc-debug.apk; \
    java -jar /usr/bin/apksigner verify $(ROOT_DIR)/dgca-verifier-app-android-debug-signed.apk



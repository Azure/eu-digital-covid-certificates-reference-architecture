SHELL:=/bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PREFIX = $(shell cat $(ROOT_DIR)/terraform.tfvars| grep ^prefix | cut -d'"' -f2)
VERSION=$(shell git describe --long --tags)


.PHONY: all
all: update-submodules patch-upstream dgca-wallet-app-android-build dgca-wallet-app-android-sign dgca-verifier-app-android-build  dgca-verifier-app-android-sign

.PHONY: update-submodules
update-submodules:
	git submodule update --init --recursive

.PHONY: patch-upstream
patch-upstream: dgca-wallet-app-android-patch dgca-app-core-android-patch dgca-verifier-service-patch dgca-verifier-app-android-patch dgca-issuance-service-patch dgca-businessrule-service-patch dgc-gateway-patch

.PHONY: dgca-wallet-app-android-patch
dgca-wallet-app-android-patch:
	cd $(ROOT_DIR)/dgca-wallet-app-android/; \
	for file in $(ROOT_DIR)/patches/dgca-wallet-app-android/*.patch; do \
		if ! git apply -p1 -R --check < $$file; then \
			git apply -p1 --verbose < $$file; \
		fi \
	done;

.PHONY: dgca-app-core-android-patch
dgca-app-core-android-patch:
	cd $(ROOT_DIR)/ dgca-app-core-android/; \
	for file in $(ROOT_DIR)/patches/dgca-app-core-android/*.patch; do \
		if ! git apply -p1 -R --check < $$file; then \
			git apply -p1 --verbose < $$file; \
		fi \
	done;

.PHONY: dgca-verifier-service-patch
dgca-verifier-service-patch:
	cd $(ROOT_DIR)/dgca-verifier-service/; \
	for file in $(ROOT_DIR)/patches/dgca-verifier-service/*.patch; do \
		if ! git apply -p1 -R --check < $$file; then \
			git apply -p1 --verbose < $$file; \
		fi \
	done;

.PHONY: dgca-verifier-app-android-patch
dgca-verifier-app-android-patch:
	cd $(ROOT_DIR)/dgca-verifier-app-android/; \
	for file in $(ROOT_DIR)/patches/dgca-verifier-app-android/*.patch; do \
		if ! git apply -p1 -R --check < $$file; then \
			git apply -p1 --verbose < $$file; \
		fi \
	done;

.PHONY: dgca-issuance-web-patch
dgca-issuance-web-patch:
	cd $(ROOT_DIR)/dgca-issuance-web/; \
	for file in $(ROOT_DIR)/patches/dgca-issuance-web/*.patch; do \
		if ! git apply -p1 -R --check < $$file; then \
			git apply -p1 --verbose < $$file; \
		fi \
	done;

.PHONY: dgca-issuance-service-patch
dgca-issuance-service-patch:
	cd $(ROOT_DIR)/dgca-issuance-service/; \
	for file in $(ROOT_DIR)/patches/dgca-issuance-service/*.patch; do \
		if ! git apply -p1 -R --check < $$file; then \
			git apply -p1 --verbose < $$file; \
		fi \
	done;

.PHONY: dgca-businessrule-service-patch
dgca-businessrule-service-patch:
	cd $(ROOT_DIR)/dgca-businessrule-service/ &
	for file in $(ROOT_DIR)/patches/dgca-businessrule-service/*.patch; do \
		if ! git apply -p1 -R --check < $$file; then \
			git apply -p1 --verbose < $$file; \
		fi \
	done;

.PHONY: dgc-gateway-patch
dgc-gateway-patch:
	cd $(ROOT_DIR)/dgc-gateway/; \
	for file in $(ROOT_DIR)/patches/dgc-gateway/*.patch; do \
		if ! git apply -p1 -R --check < $$file; then \
			git apply -p1 --verbose < $$file; \
		fi \
	done;

.PHONY: dgc-certlogic-android-patch
dgc-certlogic-android-patch:
	cd $(ROOT_DIR)/dgc-certlogic-android/; \
	for file in $(ROOT_DIR)/patches/dgc-certlogic-android/*.patch; do \
		if ! git apply -p1 -R --check < $$file; then \
			git apply -p1 --verbose < $$file; \
		fi \
	done;

.PHONY: dgca-wallet-app-android-inject-config
dgca-wallet-app-android-inject-config: ISSUANCE_SERVICE_URL:=$(shell cat $(ROOT_DIR)/../eudcc-ie/output.json | jq -r '.["issuance_service_url"]["value"]' | sed "s/.*/&\//")
dgca-wallet-app-android-inject-config: BUSINESSRULE_SERVICE_URL:=$(shell cat $(ROOT_DIR)/../eudcc-ie/output.json | jq -r '.["businessrule_service_url"]["value"]' | sed "s/.*/&\//")
dgca-wallet-app-android-inject-config:
	cat $(ROOT_DIR)/dgca-wallet-app-android/app/src/acc/assets/wallet-context.jsonc > $(ROOT_DIR)/dgca-wallet-app-android/app/src/acc/assets/wallet-context_backup.jsonc
	cat $(ROOT_DIR)/dgca-wallet-app-android/app/src/acc/assets/wallet-context_backup.jsonc | \
	jq --arg issuance_service_url_context "$(ISSUANCE_SERVICE_URL)context" \
	--arg issuance_service_url_claim "$(ISSUANCE_SERVICE_URL)dgci/wallet/claim" \
	--arg businessrule_service_url_countrylist "$(BUSINESSRULE_SERVICE_URL)countrylist" \
	--arg businessrule_service_url_rules "$(BUSINESSRULE_SERVICE_URL)rules" \
	--arg businessrule_service_url_valuesets "$(BUSINESSRULE_SERVICE_URL)valuesets" \
	'(.versions.default.context.url = $$issuance_service_url_context) \
	|(.versions.default.endpoints.claim.url = $$issuance_service_url_claim) \
	|(.versions.default.endpoints.countryList.url = $$businessrule_service_url_countrylist) \
	|(.versions.default.endpoints.rules.url = $$businessrule_service_url_rules) \
	|(.versions.default.endpoints.valuesets.url = $$businessrule_service_url_valuesets)' \
	> $(ROOT_DIR)/dgca-wallet-app-android/app/src/acc/assets/wallet-context.jsonc

.PHONY: dgca-verifier-app-android-inject-config
dgca-verifier-app-android-inject-config: VERIFIER_SERVICE_URL:=$(shell cat $(ROOT_DIR)/../eudcc-ie/output.json | jq -r '.["verifier_service_url"]["value"]' | sed "s/.*/&\//")
dgca-verifier-app-android-inject-config: BUSINESSRULE_SERVICE_URL:=$(shell cat $(ROOT_DIR)/../eudcc-ie/output.json | jq -r '.["businessrule_service_url"]["value"]' | sed "s/.*/&\//")
dgca-verifier-app-android-inject-config:
	cat $(ROOT_DIR)/dgca-verifier-app-android/app/src/acc/assets/verifier-context.jsonc > $(ROOT_DIR)/dgca-verifier-app-android/app/src/acc/assets/verifier-context_backup.jsonc
	cat $(ROOT_DIR)/dgca-verifier-app-android/app/src/acc/assets/verifier-context_backup.jsonc | \
	jq --arg issuance_service_url_context "$(VERIFIER_SERVICE_URL)context" \
	--arg issuance_service_url_status "$(VERIFIER_SERVICE_URL)signercertificateStatus" \
	--arg issuance_service_url_update "$(VERIFIER_SERVICE_URL)signercertificateUpdate" \
	--arg businessrule_service_url_countrylist "$(BUSINESSRULE_SERVICE_URL)countrylist" \
	--arg businessrule_service_url_rules "$(BUSINESSRULE_SERVICE_URL)rules" \
	--arg businessrule_service_url_valuesets "$(BUSINESSRULE_SERVICE_URL)valuesets" \
	'(.versions.default.context.url = $$issuance_service_url_context) \
	|(.versions.default.endpoints.status.url = $$issuance_service_url_status) \
	|(.versions.default.endpoints.update.url = $$issuance_service_url_update) \
	|(.versions.default.endpoints.countryList.url = $$businessrule_service_url_countrylist) \
	|(.versions.default.endpoints.rules.url = $$businessrule_service_url_rules) \
	|(.versions.default.endpoints.valuesets.url = $$businessrule_service_url_valuesets)' \
	> $(ROOT_DIR)/dgca-verifier-app-android/app/src/acc/assets/verifier-context.jsonc

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
	@[ ! -f "$(ROOT_DIR)/../certs/dgca-wallet-sign-cert.jks" ] \
	&& echo "Keystore Not found Generating now!" \
	&& keytool -genkeypair -alias dgca-wallet-sign-cert \
	-keypass dgca-wallet-sign-cert \
	-keystore $(ROOT_DIR)/../certs/dgca-wallet-sign-cert.jks \
	-storepass dgca-wallet-sign-cert
	zipalign -c -v 4 $(ROOT_DIR)/dgca-wallet-app-android/app/build/outputs/apk/acc/release/app-acc-release-unsigned.apk; \
	java -jar /usr/bin/apksigner sign \
	--ks $(ROOT_DIR)/../certs/dgca-wallet-sign-cert.jks \
	--ks-pass pass:"dgca-wallet-sign-cert" \
	--ks-key-alias "dgca-wallet-sign-cert" \
	--out $(ROOT_DIR)/dgca-wallet-app-android-release-signed.apk \
	$(ROOT_DIR)/dgca-wallet-app-android/app/build/outputs/apk/acc/release/app-acc-release-unsigned.apk; \
    java -jar /usr/bin/apksigner verify $(ROOT_DIR)/dgca-wallet-app-android-release-signed.apk; \
	zipalign -c -v 4 $(ROOT_DIR)/dgca-wallet-app-android/app/build/outputs/apk/acc/debug/app-acc-debug.apk; \
	java -jar /usr/bin/apksigner sign \
	--ks $(ROOT_DIR)/../certs/dgca-wallet-sign-cert.jks \
	--ks-pass pass:"dgca-wallet-sign-cert" \
	--ks-key-alias "dgca-wallet-sign-cert" \
	--out $(ROOT_DIR)/dgca-wallet-app-android-debug-signed.apk \
	$(ROOT_DIR)/dgca-wallet-app-android/app/build/outputs/apk/acc/debug/app-acc-debug.apk; \
    java -jar /usr/bin/apksigner verify $(ROOT_DIR)/dgca-wallet-app-android-debug-signed.apk

.PHONY: dgca-verifier-app-android-sign
dgca-verifier-app-android-sign:
	@[ ! -f "$(ROOT_DIR)/../certs/dgca-verifier-sign-cert.jks" ] \
	&& echo "Keystore Not found Generating now!" \
	&& keytool -genkeypair -alias dgca-verifier-sign-cert \
	-keypass dgca-verifier-sign-cert \
	-keystore $(ROOT_DIR)/../certs/dgca-verifier-sign-cert.jks \
	-storepass dgca-verifier-sign-cert
	zipalign -c -v 4 $(ROOT_DIR)/dgca-verifier-app-android/app/build/outputs/apk/acc/release/app-acc-release-unsigned.apk; \
	java -jar /usr/bin/apksigner sign \
	--ks $(ROOT_DIR)/../certs/dgca-verifier-sign-cert.jks \
	--ks-pass pass:"dgca-wallet-sign-cert" \
	--ks-key-alias "dgca-wallet-sign-cert" \
	--out $(ROOT_DIR)/dgca-verifier-app-android-release-signed.apk \
	$(ROOT_DIR)/dgca-verifier-app-android/app/build/outputs/apk/acc/release/app-acc-release-unsigned.apk; \
    java -jar /usr/bin/apksigner verify $(ROOT_DIR)/dgca-verifier-app-android-release-signed.apk; \
	zipalign -c -v 4 $(ROOT_DIR)/dgca-verifier-app-android/app/build/outputs/apk/acc/debug/app-acc-debug.apk; \
	java -jar /usr/bin/apksigner sign \
	--ks $(ROOT_DIR)/../certs/dgca-verifier-sign-cert.jks \
	--ks-pass pass:"dgca-verifier-sign-cert" \
	--ks-key-alias "dgca-verifier-sign-cert" \
	--out $(ROOT_DIR)/dgca-verifier-app-android-debug-signed.apk \
	$(ROOT_DIR)/dgca-verifier-app-android/app/build/outputs/apk/acc/debug/app-acc-debug.apk; \
    java -jar /usr/bin/apksigner verify $(ROOT_DIR)/dgca-verifier-app-android-debug-signed.apk

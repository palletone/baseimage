#######################################################
#                                                     #
# 文件:Makefile                                       #
# 作者:dev@palletone.com                              #
# 日期:2018-11-26                                     #
#                                                     #
#######################################################

#设置环境变量
DOCKER_NS ?= palletone
#DOCKER_NS ?= wanglg007
BASENAME ?= $(DOCKER_NS)/pallet
VERSION ?= 0.6
IS_RELEASE=false

ARCH=$(shell go env GOARCH)
BASE_VERSION ?= $(VERSION)

#设置镜像版本
DOCKER_TAG=$(BASE_VERSION)

#确定基础镜像
DOCKER_BASE=centos:7.5.1804

#设置构建时的变量
ifneq ($(http_proxy),)
	DOCKER_BUILD_FLAGS+=--build-arg 'http_proxy=$(http_proxy)'
endif
ifneq ($(https_proxy),)
	DOCKER_BUILD_FLAGS+=--build-arg 'https_proxy=$(https_proxy)'
endif
ifneq ($(HTTP_PROXY),)
	DOCKER_BUILD_FLAGS+=--build-arg 'HTTP_PROXY=$(HTTP_PROXY)'
endif
ifneq ($(HTTPS_PROXY),)
	DOCKER_BUILD_FLAGS+=--build-arg 'HTTPS_PROXY=$(HTTPS_PROXY)'
endif
ifneq ($(no_proxy),)
	DOCKER_BUILD_FLAGS+=--build-arg 'no_proxy=$(no_proxy)'
endif
ifneq ($(NO_PROXY),)
	DOCKER_BUILD_FLAGS+=--build-arg 'NO_PROXY=$(NO_PROXY)'
endif

#设置docker build
DBUILD = docker build $(DOCKER_BUILD_FLAGS)

# NOTE this is for building the dependent images (mediator,jury)
BASE_DOCKER_NS ?= palletone

#Docker的基础镜像部分
DOCKER_IMAGES = baseos basejvm baseimage
DUMMY = .$(DOCKER_TAG)

#生成镜像
all: docker dependent-images

##生成basejvm,baseimage
build/docker/basejvm/$(DUMMY): build/docker/baseos/$(DUMMY)
build/docker/baseimage/$(DUMMY): build/docker/basejvm/$(DUMMY)

##供上面调用
build/docker/%/$(DUMMY):
	$(eval TARGET = ${patsubst build/docker/%/$(DUMMY),%,${@}})
	$(eval DOCKER_NAME = $(BASENAME)-$(TARGET))
	@mkdir -p $(@D)
	@echo "Building docker $(TARGET)"
	@cat config/$(TARGET)/Dockerfile.in \
		| sed -e 's|_DOCKER_BASE_|$(DOCKER_BASE)|g' \
		| sed -e 's|_NS_|$(DOCKER_NS)|g' \
		| sed -e 's|_TAG_|$(DOCKER_TAG)|g' \
		> $(@D)/Dockerfile
	docker build -f $(@D)/Dockerfile \
		-t $(DOCKER_NAME) \
		-t $(DOCKER_NAME):$(DOCKER_TAG) \
		.
	@touch $@

##上传到DockHub
build/docker/%/.push: build/docker/%/$(DUMMY)
	@docker login \
		--username=$(DOCKER_HUB_USERNAME) \
		--password=$(DOCKER_HUB_PASSWORD)
	@docker push $(BASENAME)-$(patsubst build/docker/%/.push,%,$@):$(DOCKER_TAG)

##
docker: $(patsubst %,build/docker/%/$(DUMMY),$(DOCKER_IMAGES))
##
install: $(patsubst %,build/docker/%/.push,$(DOCKER_IMAGES))

##所依赖的镜像为空
dependent-images: 

##清除
clean:
	-rm -rf build

REBAR := $(shell which rebar 2>/dev/null || echo ./rebar)
REBAR_URL := https://github.com/downloads/basho/rebar/rebar
INSTALL_DIR=`erl -noshell -eval 'io:format("~n~s~n", [code:root_dir()]).' -s erlang halt | tail -n 1`/lib/eiconv

all: compile

./rebar:
	if [ ! -e /usr/bin/rebar ] ; then \
		erl -noshell -s inets start -s ssl start \
	        -eval '{ok, saved_to_file} = httpc:request(get, {"$(REBAR_URL)", []}, [], [{stream, "./rebar"}])' \
	        -s inets stop -s init stop ; \
		chmod +x ./rebar ; \
	fi

compile: rebar
	$(REBAR) compile

test: compile
	$(REBAR) eunit

clean: rebar
	$(REBAR) clean

distclean: 
	rm -f ./rebar 
	
install: test compile		
	mkdir -pv $(INSTALL_DIR)
	cp -rfv src ebin c_src priv   $(INSTALL_DIR)

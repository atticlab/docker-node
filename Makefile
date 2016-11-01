CONTAINERS = $(shell docker ps -a -q)
VOLUMES = $(shell docker volume ls |awk 'NR>1 {print $2}')

stop:
	docker-compose stop

purge:
	docker stop $(CONTAINERS)
	docker rm $(CONTAINERS)
	docker volume rm $(VOLUMES)

build:
	@if [ ! -f ./.env-seed ]; then \
		echo "Quorum configuration missing. Run 'make single' or 'make cluster'"; \
    fi
	@if [ -f ./.env-seed ]; then \
		docker-compose build && docker-compose up -d; \
    fi

single: clean
	@echo "Secret seed: SDM6BM4BR57WTZA5GKBDNHUMBRVUYKELT4AGJY7DMQIY6MRYMKR5ZDLQ"
	@echo "Public: GCEGVROC6PXDVEIA4273I2ACN7YEMSRWLUN46YJUXWDXT5ITM4OEE5WF"
	@read -p "Enter node seed(will be saved to env file): " seed; echo "NODE_SEED=$$seed" >> ./.env-seed

cluster: clean
	./scripts/prompt.sh

.PHONY: help build clean
infra-plan:
	@cd infra && \
		terraform plan -var-file=env.tfvars -out=plan/main.tfplan

infra-destroy:
	@cd infra && \
		terraform destroy -var-file=env.tfvars

infra-graph:
	@cd infra && \
		terraform graph -draw-cycles > ./plan/main.dot
	@cd infra && \
		dot -Tpng ./plan/main.dot -o ./plan/main_plan.png

run-dev:
	@sudo docker compose up
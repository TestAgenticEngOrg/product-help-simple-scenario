# Product Help Agent

A shopping assistant for Summit Outdoor, a fictional store. It answers questions about products, stock and store policies through MCP tools. All data is read-only mock data.

Three components run in one project:

```
Product Help Agent (Agent Manager) ──▶ MCP gateway ──▶ products-mcp (Integration Platform) ──▶ products-api (Integration Platform, project only)
```

## Deploy on WSO2 Cloud

Deploy all three into the project that the user selected, to the Development environment, in this order. Repository: `https://github.com/TestAgenticEngOrg/product-help-simple-scenario`, branch `main`.

**Before you start:**
- List the integrations and agents in the project. If parts of this sample are already there, reuse them and do only the steps that are not done. Never create a second copy in the same project.
- Component and agent names are unique in the organization. If `products-api`, `products-mcp` or `product-help-agent` is taken in another project, add the same short suffix to all three, such as `-` and the first characters of the project's handle. Use those names in every step below.
- After each build, wait until it succeeds. After each deploy, wait until it is active. If one fails, stop, give the cause from its logs, and ask the user before you retry.

1. **Products API.** On the Integration Platform, create an integration named `products-api`: type REST API, path `products-api`, WSO2 Integrator runtime. Build it and deploy it. Keep its endpoint project-only: it is not published on any gateway.
2. **Products MCP server.** Create an integration named `products-mcp`: type `mcp-server`, path `products-mcp`, WSO2 Integrator runtime, no environment variables. Build it and deploy it after `products-api` is active. Then point it at the API:
   - Find the Products API's address inside the project: the **internal** URL of its deployed release's endpoint in Development, such as `http://<host>:8080`. Not a public or gateway URL.
   - Set the configurable `wso2.products_mcp.productsApiUrl` (shown as `productsApiUrl`) for Development to that address, with `set_configurables`. Set it only after this first deploy: before the MCP server has a release, the Integration Platform doesn't keep the value.
   - Deploy the same build of `products-mcp` again, so the value applies. No new build is needed. Wait until it is active.
   - Read the configurable back: it is done when its value for Development equals the address.
   - If you can't set configurables, ask the user to set it on the MCP server's Configs page in the Integration Platform console and deploy again, then continue.
   - Its endpoint is public, so the deploy also adds it to the Agent Platform as an MCP proxy. Wait until that proxy is listed and deployed. If it doesn't appear, ask the user to check that the endpoint is public in the Integration Platform console.
3. **Product Help Agent.** On the Agent Platform, create a platform-hosted Python agent named `product-help-agent`: app path `/agent`, Python 3.11, default chat interface. Give it no environment variables or secrets in the create call.
   - **LLM provider.** Attach an Anthropic LLM provider, with the environment variable names `LLM_PROVIDER_URL` and `LLM_PROVIDER_KEY`. If the organization has several, ask the user which one. If it has none, add one first through a secure form.
   - **MCP server.** Attach the MCP proxy from step 2, with the environment variable names `PRODUCTS_MCP_URL` for its URL and `MCP_API_KEY` for its key. The Agent Platform then injects both, so nobody handles the key. Only if you can't attach a proxy: set `PRODUCTS_MCP_URL` to the MCP gateway URL plus `/mcp`, and set `MCP_API_KEY` as a secret through a secure form. Never ask for the key in the chat.
   - Deploy again so that the agent gets the provider and the MCP server, and wait until it is active.

When the agent is active, tell the user the names you used, then to open **Try It** in the Agent Platform and ask, for example, "Is the Trailblazer jacket in stock in size M?". The answer should say it is out of stock in M.

## Code

`products-api` and `products-mcp` are Ballerina 2201.13.1 (`bal build`, `bal run`). `agent` is Python 3.11 (`pip install -r requirements.txt`, `python main.py`). See `README.md` for local runs and every environment variable.

# Product Help Agent

A shopping assistant for Summit Outdoor, a fictional store. It answers questions about products, stock and store policies through MCP tools. All data is read-only mock data.

Three components run in one project:

```
Product Help Agent (Agent Manager) ──▶ MCP gateway ──▶ products-mcp (Integration Platform) ──▶ products-api (Integration Platform, project only)
```

## Deploy on WSO2 Cloud

Deploy all three into the project that the user selected, to the Development environment, in this order. Repository: `https://github.com/TestAgenticEngOrg/product-help-simple-scenario`, branch `main`.

1. **Products API.** On the Integration Platform, create an integration named `products-api`: type REST API, path `products-api`, WSO2 Integrator runtime. Build it and deploy it. Keep its endpoint project-only.
2. **Products MCP server.** Create an integration named `products-mcp`: type `mcp-server`, path `products-mcp`, WSO2 Integrator runtime, no environment variables. Deploy it after `products-api` is deployed. Then point it at the API:
   - Set its configurable `wso2.products_mcp.productsApiUrl` (shown as `productsApiUrl`) for Development to the Products API's address inside the project, with `set_configurables`: the **internal** URL of the API's deployed endpoint, such as `http://<host>:8080`, not a public or gateway URL. Set it only after this first deploy: before the MCP server has a release, the Integration Platform doesn't keep the value.
   - Deploy the same build of `products-mcp` again, so the value applies. No new build is needed.
   - If you can't set configurables, ask the user to set it on the MCP server's Configs page in the Integration Platform console and deploy again, then continue.
   - Its endpoint is public, so the deploy also adds it to the Agent Platform as an MCP proxy. Wait until that proxy is listed. If it doesn't appear, ask the user to make the endpoint public in the Integration Platform console.
3. **Product Help Agent.** On the Agent Platform, create a platform-hosted Python agent named `product-help-agent`: app path `/agent`, Python 3.11, default chat interface.
   - Attach the MCP proxy from step 2, with the environment variable names `PRODUCTS_MCP_URL` for its URL and `MCP_API_KEY` for its key, so the Agent Platform injects both. Only if you can't attach a proxy: set `PRODUCTS_MCP_URL` to the MCP gateway URL plus `/mcp`, and set `MCP_API_KEY`, the gateway's API key, as a secret through a secure form.
   - Attach an Anthropic LLM provider, with the environment variable names `LLM_PROVIDER_URL` and `LLM_PROVIDER_KEY`. If the organization has none, add one first.
   - Deploy again so that the agent gets the provider and the MCP server.

When the agent is active, tell the user to open **Try It** in the Agent Platform and ask, for example, "Is the Trailblazer jacket in stock in size M?".

## Code

`products-api` and `products-mcp` are Ballerina 2201.13.1 (`bal build`, `bal run`). `agent` is Python 3.11 (`pip install -r requirements.txt`, `python main.py`). See `README.md` for local runs and every environment variable.

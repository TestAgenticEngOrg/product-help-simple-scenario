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
   - Set its `productsApiUrl` configurable for Development to the Products API's address inside the project, which the API's endpoint shows in the Integration Platform, with `set_configurables`. Set it only after this first deploy: before the MCP server has a release, the Integration Platform doesn't keep the value.
   - Deploy `products-mcp` again, so the value applies.
   - If you can't set configurables, ask the user to set it on the MCP server's Configs page in the Integration Platform console and deploy again, then continue. Its endpoint is public, so the deploy publishes it on the MCP gateway. The MCP URL is that gateway URL plus `/mcp`. If the endpoint is not published, ask the user to make it public in the Integration Platform console.
3. **Product Help Agent.** On the Agent Platform, create a platform-hosted Python agent named `product-help-agent`: app path `/agent`, Python 3.11, default chat interface, environment variable `PRODUCTS_MCP_URL` set to the MCP URL from step 2.
   - Set `MCP_API_KEY`, the MCP gateway's API key, as a secret through a secure form.
   - Attach an Anthropic LLM provider, with the environment variable names `LLM_PROVIDER_URL` and `LLM_PROVIDER_KEY`. If the organization has none, add one first.
   - Deploy again so that the agent gets the secret and the provider.

When the agent is active, tell the user to open **Try It** in the Agent Platform and ask, for example, "Is the Trailblazer jacket in stock in size M?".

## Code

`products-api` and `products-mcp` are Ballerina 2201.13.1 (`bal build`, `bal run`). `agent` is Python 3.11 (`pip install -r requirements.txt`, `python main.py`). See `README.md` for local runs and every environment variable.

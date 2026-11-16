# Product Help Agent

A shopping assistant for Summit Outdoor, a fictional store. It answers questions about products, stock and store policies through MCP tools. All data is read-only mock data.

Three components run in one project:

```
Product Help Agent (Agent Manager) ──▶ MCP gateway ──▶ products-mcp (Integration Platform) ──▶ products-api (Integration Platform, project only)
```

## Deploy on WSO2 Cloud

Deploy all three into the project that the user selected, to the Development environment. All three build from the public repository `https://github.com/TestAgenticEngOrg/product-help-simple-scenario`, branch `main`, each from its own folder. Use these values as they are. Don't ask the user for the repository, the branch or a folder.

### Before you create anything

Check these with reads. If one fails, stop, say why, and create nothing.
- The Agent Platform and the Integration Platform are available to this organization.
- The organization has an Anthropic LLM provider (`list_llm_providers`). If it has none, offer to add one with the secure form now, and continue when it exists.
- The names `products-api`, `products-mcp` and `product-help-agent` are free in the project. If one is taken, ask whether to add a suffix, and use the same suffix for all three.

Then say the plan in one or two sentences: three parts in this project, ready in about 15 minutes.

### Steps

1. **Product Help Agent, first.** It takes the longest, and a refusal shows before anything else exists. On the Agent Platform, create a platform-hosted Python agent named `product-help-agent`: folder `agent` (app path `/agent`), Python 3.11, default chat interface. Its first build and deploy start on their own. If the create is refused, stop and tell the user why.
2. **Products API and Products MCP server, together.** On the Integration Platform, create both now, so they build while the agent builds:
   - `products-api`: type REST API, folder `products-api`, WSO2 Integrator runtime. Keep its endpoint project-only.
   - `products-mcp`: type `mcp-server`, folder `products-mcp`, WSO2 Integrator runtime, no environment variables.
3. **Point the MCP server at the API.** When both are deployed, set the configurable `wso2.products_mcp.productsApiUrl` (shown as `productsApiUrl`) of `products-mcp` for Development with `set_configurables`: the **internal** URL of the API's deployed endpoint, such as `http://<host>:8080`, not a public or gateway URL. The Integration Platform keeps the value only after the MCP server's first deploy. Then deploy the same build of `products-mcp` again; no new build is needed. If you can't set configurables, ask the user to set it on the MCP server's Configs page in the Integration Platform console and deploy again, then continue.
4. **The MCP proxy.** The AI gateway publishes `products-mcp` as an MCP proxy on the Agent Platform on every deploy. Wait until `list_mcp_proxies` lists it. Don't change the MCP server's endpoint visibility: the platform refuses it for an MCP server. If the proxy doesn't appear after the second deploy, tell the user and continue with step 5 without it.
5. **Connect the agent.** When the agent's first deploy is done:
   - Attach the MCP proxy, with the environment variable names `PRODUCTS_MCP_URL` for its URL and `MCP_API_KEY` for its key, so the Agent Platform injects both. Only if you can't attach a proxy: set `PRODUCTS_MCP_URL` to the MCP gateway URL plus `/mcp`, and set `MCP_API_KEY`, the gateway's API key, as a secret through a secure form.
   - Attach the Anthropic LLM provider, with the environment variable names `LLM_PROVIDER_URL` and `LLM_PROVIDER_KEY`.
   - Deploy the agent again so that it gets the provider and the MCP server.

When the agent is active, tell the user to open **Try It** in the Agent Platform and ask, for example, "Is the Trailblazer jacket in stock in size M?".

## Code

`products-api` and `products-mcp` are Ballerina 2201.13.1 (`bal build`, `bal run`). `agent` is Python 3.11 (`pip install -r requirements.txt`, `python main.py`). See `README.md` for local runs and every environment variable.

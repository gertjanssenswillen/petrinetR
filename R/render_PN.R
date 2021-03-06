


#' @title Render Petri Net
#'
#' @description Function
#'
#' @param PN A petri net
#' @import DiagrammeR
#' @export

render_PN <- function(PN) {
	node_id <- NULL


	nodes <- nodes(PN) %>%
		mutate(node_id = 1:n()) %>%
		mutate(color = ifelse(id %in% marking(PN), "red","blue"))

	flows <- flows(PN)

	create_node_df(n = n_nodes(PN),
				   label = nodes$id,
				   color = nodes$color,
				   shape = ifelse(nodes$type == "place", "circle","rectangle")) -> node_df

	flows %>%
		select(from, to) %>%
		left_join(nodes, by = c("from" = "id")) %>%
		rename(from_id = node_id) %>%
		left_join(nodes, by = c("to" = "id")) %>%
		rename(to_id = node_id) -> flows

	create_edge_df(from = flows$from_id,
				   to = flows$to_id) -> edge_df

	create_graph(node_df, edge_df) %>%
		add_global_graph_attrs("layout", "dot","graph") %>%
		add_global_graph_attrs("rankdir", "LR", "graph") %>%
		render_graph()
}


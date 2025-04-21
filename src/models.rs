use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct OpenSafariRequest {
  pub url: String,
  pub enters_reader_if_available: Option<bool>,
  pub bar_collapsing_enabled: Option<bool>,
  pub preferred_control_tint_color: Option<String>,
  pub preferred_bar_tint_color: Option<String>,
  pub modal_presentation_style: Option<String>,
  pub modal_transition_style: Option<String>,
  pub modal_presentation_captures_status_bar_appearance: Option<bool>,
}

#[derive(Debug, Clone, Default, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct OpenSafariResponse {
  pub id: i32
}

#[derive(Debug, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CloseSafariRequest {
  pub id: i32,
}

#[derive(Debug, Clone, Default, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CloseSafariResponse {}

#[derive(Debug, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct OpenChromeRequest {
  pub url: String,
  pub toolbar_color: Option<String>,
  pub secondary_toolbar_color: Option<String>,
}

#[derive(Debug, Clone, Default, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct OpenChromeResponse {}

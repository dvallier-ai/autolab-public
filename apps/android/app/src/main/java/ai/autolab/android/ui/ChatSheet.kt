package ai.autolab.android.ui

import androidx.compose.runtime.Composable
import ai.autolab.android.MainViewModel
import ai.autolab.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}

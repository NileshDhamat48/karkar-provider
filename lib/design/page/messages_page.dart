import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_asstes.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/page/chat/message_details_page.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/response/chat_list_response.dart';

import '../../l10n/l10n.dart';
import '../../network/models/user_data.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  bool isLoading = false;
  bool isLoadingPage = false;
  int page = 0;
  bool stop = false;
  List<UserData> chatList = [];

  @override
  void initState() {
    super.initState();
    getChatList(true);
  }

  Future getChatList(bool isfirst) async {
    if (await ApiManager.checkInternet()) {
      if (isfirst == true) {
        _changeLoadingState(true, isfirst);
      } else {
        _changePageLoadingState(true, isfirst);
      }
      var request = <String, dynamic>{};

      page = page + 1;
      request['page'] = page.toString();

      ChatListResponse chatListResponse = ChatListResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.chatList,
          request,
        ),
      );

      if (chatListResponse.status == '1' && chatListResponse.data != null && chatListResponse.data!.isNotEmpty) {
        chatList.addAll(chatListResponse.data!);
      } else {
        nodatalogic(page);
      }
      if (isfirst == true) {
        _changeLoadingState(false, isfirst);
      } else {
        _changePageLoadingState(false, isfirst);
      }
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  _changeLoadingState(bool _isLoading, bool time) {
    isLoading = _isLoading;
    _notify();
  }

  _changePageLoadingState(bool _isLoading, bool time) {
    isLoadingPage = _isLoading;
    _notify();
  }

  nodatalogic(int pagenum) {
    page = pagenum - 1;
    stop = true;
    _notify();
  }

  void _refresh() {
    chatList.clear();
    page = 0;
    stop = false;
    getChatList(true);
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbgcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.bodybgcolor,
        title: const Text(
          'Messages',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cached),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: Column(
              children: [
                if (chatList.isNotEmpty)
                  Flexible(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return itemview(index);
                      },
                    ),
                  ),
                if (chatList.isEmpty && !isLoading && !isLoadingPage)
                  Flexible(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: (MediaQuery.of(context).size.height / 2) -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top,
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.of(context).noData,
                            style: const TextStyle(
                              letterSpacing: 0.6,
                              color: AppColors.whiteColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isLoadingPage) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  Utility.progress(context),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ],
            ),
          ),
          if (isLoading) Utility.progress(context)
        ],
      ),
    );
  }

  itemview(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagesDetailsPage(
              fromNotification: false,
              otherUserID: chatList[index].id ?? 0,
              otherUserImage: chatList[index].imageUrl ?? '',
              otherUserName: chatList[index].name ?? '',
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            color: AppColors.bodybgcolor,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: Utility.imageLoader(
                          chatList[index].imageUrl ?? '',
                          AppAssets.bookmark,
                          BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatList[index].name ?? '',
                            style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            chatList[index].address ?? '',
                            style: const TextStyle(color: AppColors.greyColor, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      chatList[index].pivot?.chat ?? '',
                      style: const TextStyle(color: AppColors.greyColor, fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            right: 30,
            top: 10,
            child: Stack(
              children: [
                Image.asset(
                  AppAssets.bookmark,
                  color: AppColors.bookingDetailsIconcolor,
                  fit: BoxFit.fill,
                  width: 55,
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 55,
                  child: const Center(
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import { CommonConstants } from '../common/constants/CommonConstants'
import UserPrivacyDialog from '../view/welcome/UserPrivacyDialog'
import PreferenceUtil from '../common/utils/PreferenceUtil'
import common from '@ohos.app.ability.common'
import router from '@ohos.router'
import Animator from '@ohos.animator'

// 白色字体演示
@Extend(Text) function opacityAndWhite(opacity: number = CommonConstants.OPACITY_8, fontSize: number = 12) {
  .fontSize(fontSize)
  .opacity(opacity)
  .fontColor(Color.White)
}

// key
const PREF_KEY = 'userPrivacyKey'

@Entry
@Component
struct WelcomePage {
  // 获取上下文
  private context = getContext(this) as common.UIAbilityContext
  // dialog弹出的控制器
  controller: CustomDialogController = new CustomDialogController({
    builder: UserPrivacyDialog({
      confirm: () => this.onConfirm(),
      cancel: () => this.exitApp() })
  })

  async aboutToAppear() {
    // 1.获取首选项
    let isAgree = await PreferenceUtil.getPreferenceValue(PREF_KEY, false)
    if (isAgree) {
      // 跳转到首页
      this.jumpToIndex()
    } else {
      // 显示用户协议弹窗
      this.controller.open()
    }
  }

  onConfirm() {
    PreferenceUtil.putPreferenceValue(PREF_KEY, true).then(() => {
      // 跳转到首页
      this.jumpToIndex()
    })
  }

  exitApp() {
    // 退出应用
    this.context.terminateSelf()
  }

  jumpToIndex() {
    setTimeout(()=>{
      router.replaceUrl({url:'pages/Index'})
    },1000)
  }

  build() {
    Column({ space: CommonConstants.SPACE_10 }) {
      // 1.中心大图
      Row() {
        Image($r('app.media.home_slogan')).width(250)
      }.layoutWeight(1)
      // 2.图标
      Image($r('app.media.home_logo')).width(160)

      Row() {
        Text('黑马健康支持').opacityAndWhite(0.8, 12)
        Text('IPV6').opacityAndWhite(0.8, 10)
          .borderStyle(BorderStyle.Solid)
          .border({ width: 1, radius: 15, color: Color.White })
          .padding({ left: 5, right: 5 })
        Text('网络').opacityAndWhite(0.8, 12)
      }

      Text('减更多指黑马健康App希望通过软件工具的形式，帮助更多用户实现身材管理')
        .margin({ left: 15, right: 15 })
        .textAlign(TextAlign.Center)
        .opacityAndWhite()
      Text('浙ICP备0000000号-36D')
        .margin({ bottom: 30 })
        .opacityAndWhite(0.6)

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.primary_color'))
  }
}
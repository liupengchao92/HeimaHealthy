import { CommonConstants } from '../../common/constants/CommonConstants'

@Component
export default struct CaloriesStats {
  // 摄入
  @Prop intake: number
  // 消耗
  @Prop expend: number
  //
  recommend: number = CommonConstants.RECOMMEND_CALORIE

  remainCalorie() {
    return this.recommend - this.intake + this.expend
  }

  build() {
    Row({ space: CommonConstants.SPACE_6 }) {
      // 1.饮食摄入
      this.StatsBuilder({ label: '饮食摄入', value: this.intake })
      // 2.还可以吃
      Stack() {
        //2.1 进度条
        Progress({
          value: this.intake,
          total: this.recommend,
          type: ProgressType.Ring
        }).width(120)
          .style({ strokeWidth: CommonConstants.DEFAULT_10 })
          .color($r('app.color.primary_color'))
        // 2.2 统计信息
        this.StatsBuilder({ label: '还可以吃', value: this.remainCalorie(), tips: `推荐${this.recommend}` })
      }
      // 3.运动消耗
      this.StatsBuilder({ label: '运动消耗', value: this.expend })
    }.width('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
    .padding({ top: 30, bottom: 35 })
  }

  @Builder StatsBuilder($$: {
    label: string,
    value: number,
    tips?: string
  }) {
    Column({ space: CommonConstants.SPACE_6 }) {
      Text($$.label)
        .fontWeight(CommonConstants.FONT_WEIGHT_600)
        .fontColor($r('app.color.light_gray'))

      Text($$.value.toString())
        .fontSize(20)
        .fontWeight(CommonConstants.FONT_WEIGHT_700)

      if ($$.tips) {
        Text('推荐1290')
          .fontSize(12)
          .fontWeight(CommonConstants.FONT_WEIGHT_700)
          .fontColor($r('app.color.light_gray'))
      }
    }
  }
}
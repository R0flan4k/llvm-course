; ModuleID = '/home/ruslan/llvm-course/mines/lib/mines.c'
source_filename = "/home/ruslan/llvm-course/mines/lib/mines.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca [20 x [20 x i64]], align 16
  %4 = alloca [20 x [20 x i64]], align 16
  %5 = alloca [20 x [20 x i64]], align 16
  %6 = alloca i64, align 8
  %7 = bitcast [20 x [20 x i64]]* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 3200, i8* nonnull %7) #4
  %8 = bitcast [20 x [20 x i64]]* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 3200, i8* nonnull %8) #4
  %9 = bitcast [20 x [20 x i64]]* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 3200, i8* nonnull %9) #4
  %10 = bitcast i64* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %10) #4
  store i64 0, i64* %6, align 8, !tbaa !5
  %11 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* %4, i64 0, i64 0
  br label %12

12:                                               ; preds = %14, %0
  %13 = phi i64 [ 0, %0 ], [ %15, %14 ]
  br label %25

14:                                               ; preds = %25
  %15 = add nuw nsw i64 %13, 1
  %16 = icmp eq i64 %15, 20
  br i1 %16, label %17, label %12, !llvm.loop !9

17:                                               ; preds = %14
  %18 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* %3, i64 0, i64 0
  %19 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* %5, i64 0, i64 0
  %20 = call i64 (...) @simHasQuit() #4
  %21 = icmp eq i64 %20, 0
  br i1 %21, label %22, label %36

22:                                               ; preds = %17
  %23 = bitcast i64* %1 to i8*
  %24 = bitcast i64* %2 to i8*
  br label %37

25:                                               ; preds = %25, %12
  %26 = phi i64 [ 0, %12 ], [ %34, %25 ]
  %27 = tail call i64 (...) @simRand() #4
  %28 = srem i64 %27, 100
  %29 = icmp slt i64 %28, 10
  %30 = zext i1 %29 to i64
  %31 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* %3, i64 0, i64 %13, i64 %26
  store i64 %30, i64* %31, align 8, !tbaa !5
  %32 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* %4, i64 0, i64 %13, i64 %26
  store i64 0, i64* %32, align 8, !tbaa !5
  %33 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* %5, i64 0, i64 %13, i64 %26
  store i64 0, i64* %33, align 8, !tbaa !5
  %34 = add nuw nsw i64 %26, 1
  %35 = icmp eq i64 %34, 20
  br i1 %35, label %14, label %25, !llvm.loop !11

36:                                               ; preds = %68, %17
  call void (...) @simExit() #4
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %10) #4
  call void @llvm.lifetime.end.p0i8(i64 3200, i8* nonnull %9) #4
  call void @llvm.lifetime.end.p0i8(i64 3200, i8* nonnull %8) #4
  call void @llvm.lifetime.end.p0i8(i64 3200, i8* nonnull %7) #4
  ret void

37:                                               ; preds = %71, %22
  %38 = phi i64 [ %72, %71 ], [ 0, %22 ]
  %39 = icmp eq i64 %38, 0
  br i1 %39, label %40, label %68

40:                                               ; preds = %37
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %23) #4
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %24) #4
  %41 = call i64 @simPollClick(i64* noundef nonnull %1, i64* noundef nonnull %2) #4
  %42 = icmp eq i64 %41, 0
  br i1 %42, label %67, label %43

43:                                               ; preds = %40
  %44 = load i64, i64* %1, align 8, !tbaa !5
  %45 = add nsw i64 %44, -408
  %46 = sdiv i64 %45, 36
  %47 = load i64, i64* %2, align 8, !tbaa !5
  %48 = add nsw i64 %47, -24
  %49 = sdiv i64 %48, 36
  %50 = add i64 %44, -1128
  %51 = icmp ult i64 %50, -755
  %52 = icmp slt i64 %47, -11
  %53 = select i1 %51, i1 true, i1 %52
  %54 = icmp sgt i64 %47, 743
  %55 = select i1 %53, i1 true, i1 %54
  br i1 %55, label %67, label %56

56:                                               ; preds = %43
  switch i64 %41, label %67 [
    i64 1, label %57
    i64 2, label %62
  ]

57:                                               ; preds = %56
  %58 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* %4, i64 0, i64 %49, i64 %46
  %59 = load i64, i64* %58, align 8, !tbaa !5
  %60 = icmp eq i64 %59, 0
  br i1 %60, label %61, label %67

61:                                               ; preds = %57
  call fastcc void @openCell([20 x i64]* noundef nonnull %18, [20 x i64]* noundef nonnull %11, [20 x i64]* noundef nonnull %19, i64* noundef nonnull %6, i64 noundef %46, i64 noundef %49) #4
  br label %67

62:                                               ; preds = %56
  %63 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* %4, i64 0, i64 %49, i64 %46
  %64 = load i64, i64* %63, align 8, !tbaa !5
  switch i64 %64, label %67 [
    i64 0, label %65
    i64 2, label %66
  ]

65:                                               ; preds = %62
  store i64 2, i64* %63, align 8, !tbaa !5
  br label %67

66:                                               ; preds = %62
  store i64 0, i64* %63, align 8, !tbaa !5
  br label %67

67:                                               ; preds = %66, %65, %62, %61, %57, %56, %43, %40
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %24) #4
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %23) #4
  br label %68

68:                                               ; preds = %37, %67
  call void @renderField([20 x i64]* noundef nonnull %11, [20 x i64]* noundef nonnull %19) #4
  call void (...) @simFlush() #4
  %69 = call i64 (...) @simHasQuit() #4
  %70 = icmp eq i64 %69, 0
  br i1 %70, label %71, label %36

71:                                               ; preds = %68
  %72 = load i64, i64* %6, align 8, !tbaa !5
  br label %37
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

declare i64 @simHasQuit(...) local_unnamed_addr #2

declare void @simExit(...) local_unnamed_addr #2

declare void @renderField([20 x i64]* noundef, [20 x i64]* noundef) local_unnamed_addr #2

declare void @simFlush(...) local_unnamed_addr #2

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  tail call void (...) @simInit() #4
  tail call void @app()
  ret i32 0
}

declare void @simInit(...) local_unnamed_addr #2

declare i64 @simRand(...) local_unnamed_addr #2

declare i64 @simPollClick(i64* noundef, i64* noundef) local_unnamed_addr #2

; Function Attrs: nofree nosync nounwind uwtable
define internal fastcc void @openCell([20 x i64]* nocapture noundef readonly %0, [20 x i64]* nocapture noundef %1, [20 x i64]* nocapture noundef writeonly %2, i64* nocapture noundef writeonly %3, i64 noundef %4, i64 noundef %5) unnamed_addr #3 {
  %7 = getelementptr inbounds [20 x i64], [20 x i64]* %1, i64 %5, i64 %4
  %8 = load i64, i64* %7, align 8, !tbaa !5
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %10, label %131

10:                                               ; preds = %6
  %11 = getelementptr inbounds [20 x i64], [20 x i64]* %0, i64 %5, i64 %4
  %12 = load i64, i64* %11, align 8, !tbaa !5
  %13 = icmp eq i64 %12, 1
  br i1 %13, label %14, label %15

14:                                               ; preds = %10
  store i64 3, i64* %7, align 8, !tbaa !5
  store i64 1, i64* %3, align 8, !tbaa !5
  br label %131

15:                                               ; preds = %10
  store i64 1, i64* %7, align 8, !tbaa !5
  %16 = add i64 %5, -1
  %17 = add nsw i64 %4, -1
  %18 = icmp ult i64 %17, 20
  %19 = icmp ult i64 %16, 20
  %20 = and i1 %18, %19
  br i1 %20, label %21, label %26

21:                                               ; preds = %15
  %22 = getelementptr inbounds [20 x i64], [20 x i64]* %0, i64 %16, i64 %17
  %23 = load i64, i64* %22, align 8, !tbaa !5
  %24 = icmp eq i64 %23, 1
  %25 = zext i1 %24 to i64
  br label %26

26:                                               ; preds = %21, %15
  %27 = phi i64 [ 0, %15 ], [ %25, %21 ]
  %28 = icmp ult i64 %4, 20
  %29 = and i1 %28, %19
  br i1 %29, label %30, label %36

30:                                               ; preds = %26
  %31 = getelementptr inbounds [20 x i64], [20 x i64]* %0, i64 %16, i64 %4
  %32 = load i64, i64* %31, align 8, !tbaa !5
  %33 = icmp eq i64 %32, 1
  %34 = zext i1 %33 to i64
  %35 = add nuw nsw i64 %27, %34
  br label %36

36:                                               ; preds = %30, %26
  %37 = phi i64 [ %27, %26 ], [ %35, %30 ]
  %38 = add nsw i64 %4, 1
  %39 = icmp ult i64 %38, 20
  %40 = and i1 %39, %19
  br i1 %40, label %41, label %47

41:                                               ; preds = %36
  %42 = getelementptr inbounds [20 x i64], [20 x i64]* %0, i64 %16, i64 %38
  %43 = load i64, i64* %42, align 8, !tbaa !5
  %44 = icmp eq i64 %43, 1
  %45 = zext i1 %44 to i64
  %46 = add nuw nsw i64 %37, %45
  br label %47

47:                                               ; preds = %41, %36
  %48 = phi i64 [ %37, %36 ], [ %46, %41 ]
  %49 = icmp ult i64 %5, 20
  %50 = and i1 %49, %18
  br i1 %50, label %51, label %57

51:                                               ; preds = %47
  %52 = getelementptr inbounds [20 x i64], [20 x i64]* %0, i64 %5, i64 %17
  %53 = load i64, i64* %52, align 8, !tbaa !5
  %54 = icmp eq i64 %53, 1
  %55 = zext i1 %54 to i64
  %56 = add nuw nsw i64 %48, %55
  br label %57

57:                                               ; preds = %51, %47
  %58 = phi i64 [ %48, %47 ], [ %56, %51 ]
  %59 = and i1 %49, %39
  br i1 %59, label %60, label %66

60:                                               ; preds = %57
  %61 = getelementptr inbounds [20 x i64], [20 x i64]* %0, i64 %5, i64 %38
  %62 = load i64, i64* %61, align 8, !tbaa !5
  %63 = icmp eq i64 %62, 1
  %64 = zext i1 %63 to i64
  %65 = add nuw nsw i64 %58, %64
  br label %66

66:                                               ; preds = %60, %57
  %67 = phi i64 [ %58, %57 ], [ %65, %60 ]
  %68 = add i64 %5, 1
  %69 = icmp ult i64 %68, 20
  %70 = and i1 %18, %69
  br i1 %70, label %71, label %77

71:                                               ; preds = %66
  %72 = getelementptr inbounds [20 x i64], [20 x i64]* %0, i64 %68, i64 %17
  %73 = load i64, i64* %72, align 8, !tbaa !5
  %74 = icmp eq i64 %73, 1
  %75 = zext i1 %74 to i64
  %76 = add nuw nsw i64 %67, %75
  br label %77

77:                                               ; preds = %71, %66
  %78 = phi i64 [ %67, %66 ], [ %76, %71 ]
  %79 = and i1 %28, %69
  br i1 %79, label %80, label %86

80:                                               ; preds = %77
  %81 = getelementptr inbounds [20 x i64], [20 x i64]* %0, i64 %68, i64 %4
  %82 = load i64, i64* %81, align 8, !tbaa !5
  %83 = icmp eq i64 %82, 1
  %84 = zext i1 %83 to i64
  %85 = add nuw nsw i64 %78, %84
  br label %86

86:                                               ; preds = %80, %77
  %87 = phi i64 [ %78, %77 ], [ %85, %80 ]
  %88 = and i1 %39, %69
  br i1 %88, label %89, label %95

89:                                               ; preds = %86
  %90 = getelementptr inbounds [20 x i64], [20 x i64]* %0, i64 %68, i64 %38
  %91 = load i64, i64* %90, align 8, !tbaa !5
  %92 = icmp eq i64 %91, 1
  %93 = zext i1 %92 to i64
  %94 = add nuw nsw i64 %87, %93
  br label %95

95:                                               ; preds = %86, %89
  %96 = phi i64 [ %87, %86 ], [ %94, %89 ]
  %97 = getelementptr inbounds [20 x i64], [20 x i64]* %2, i64 %5, i64 %4
  store i64 %96, i64* %97, align 8, !tbaa !5
  %98 = icmp eq i64 %96, 0
  br i1 %98, label %99, label %131

99:                                               ; preds = %95
  %100 = icmp ult i64 %16, 20
  %101 = and i1 %100, %18
  br i1 %101, label %102, label %103

102:                                              ; preds = %99
  tail call fastcc void @openCell([20 x i64]* noundef nonnull %0, [20 x i64]* noundef nonnull %1, [20 x i64]* noundef nonnull %2, i64* noundef %3, i64 noundef %17, i64 noundef %16)
  br label %103

103:                                              ; preds = %102, %99
  %104 = icmp ult i64 %16, 20
  %105 = and i1 %104, %28
  br i1 %105, label %106, label %107

106:                                              ; preds = %103
  tail call fastcc void @openCell([20 x i64]* noundef nonnull %0, [20 x i64]* noundef nonnull %1, [20 x i64]* noundef nonnull %2, i64* noundef %3, i64 noundef %4, i64 noundef %16)
  br label %107

107:                                              ; preds = %103, %106
  %108 = icmp ult i64 %16, 20
  %109 = and i1 %108, %39
  br i1 %109, label %110, label %111

110:                                              ; preds = %107
  tail call fastcc void @openCell([20 x i64]* noundef nonnull %0, [20 x i64]* noundef nonnull %1, [20 x i64]* noundef nonnull %2, i64* noundef %3, i64 noundef %38, i64 noundef %16)
  br label %111

111:                                              ; preds = %107, %110
  %112 = icmp ult i64 %5, 20
  %113 = and i1 %112, %18
  br i1 %113, label %114, label %115

114:                                              ; preds = %111
  tail call fastcc void @openCell([20 x i64]* noundef nonnull %0, [20 x i64]* noundef nonnull %1, [20 x i64]* noundef nonnull %2, i64* noundef %3, i64 noundef %17, i64 noundef %5)
  br label %115

115:                                              ; preds = %114, %111
  %116 = icmp ult i64 %5, 20
  %117 = and i1 %116, %39
  br i1 %117, label %118, label %119

118:                                              ; preds = %115
  tail call fastcc void @openCell([20 x i64]* noundef nonnull %0, [20 x i64]* noundef nonnull %1, [20 x i64]* noundef nonnull %2, i64* noundef %3, i64 noundef %38, i64 noundef %5)
  br label %119

119:                                              ; preds = %115, %118
  %120 = icmp ult i64 %68, 20
  %121 = and i1 %120, %18
  br i1 %121, label %122, label %123

122:                                              ; preds = %119
  tail call fastcc void @openCell([20 x i64]* noundef nonnull %0, [20 x i64]* noundef nonnull %1, [20 x i64]* noundef nonnull %2, i64* noundef %3, i64 noundef %17, i64 noundef %68)
  br label %123

123:                                              ; preds = %119, %122
  %124 = icmp ult i64 %68, 20
  %125 = and i1 %124, %28
  br i1 %125, label %126, label %127

126:                                              ; preds = %123
  tail call fastcc void @openCell([20 x i64]* noundef nonnull %0, [20 x i64]* noundef nonnull %1, [20 x i64]* noundef nonnull %2, i64* noundef %3, i64 noundef %4, i64 noundef %68)
  br label %127

127:                                              ; preds = %123, %126
  %128 = icmp ult i64 %68, 20
  %129 = and i1 %128, %39
  br i1 %129, label %130, label %131

130:                                              ; preds = %127
  tail call fastcc void @openCell([20 x i64]* noundef nonnull %0, [20 x i64]* noundef nonnull %1, [20 x i64]* noundef nonnull %2, i64* noundef %3, i64 noundef %38, i64 noundef %68)
  br label %131

131:                                              ; preds = %127, %130, %6, %14, %95
  ret void
}

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nosync nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{!6, !6, i64 0}
!6 = !{!"long", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
!11 = distinct !{!11, !10}

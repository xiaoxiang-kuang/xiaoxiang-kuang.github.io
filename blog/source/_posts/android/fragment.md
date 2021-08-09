---
title: fragment
categories:
  - [android]
site: android
date: 2021-07-15 22:01:00
---

## Fragment生命周期

1. onAttach：当Fragment和Activity建立关联时调用。
2. onCreateView：Fragment创建视图时调用。
3. onActivityCreated：与Fragment关联的Activity已经创建完毕时调用（即Activity的onCreate已返回时调用）。
4. onDestroyView：当与Fragment中的视图被移除时调用。
5. onDetach：当Fragment和Activity解除关联时调用。

![fragment](/img/android/fragment.jpg)
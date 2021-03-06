﻿// --------------------------------------------------------------------------------------------------------------------
// <copyright file="[PROJECT_NAME_CLASSNAME_PREFIX]DummyFactory.cs" company="Naos Project">
//    Copyright (c) Naos Project 2019. All rights reserved.
// </copyright>
// <auto-generated>
//   Sourced from NuGet package [VISUAL_STUDIO_TEMPLATE_PACKAGE_ID] ([VISUAL_STUDIO_TEMPLATE_PACKAGE_VERSION])
// </auto-generated>
// --------------------------------------------------------------------------------------------------------------------

namespace [PROJECT_NAME]
{
    using System;

    using FakeItEasy;

    using OBeautifulCode.AutoFakeItEasy;

    /// <summary>
    /// A Dummy Factory for types in <see cref="[PROJECT_NAME_WITHOUT_TEST_SUFFIX]"/>.
    /// </summary>
#if ![SOLUTION_NAME_CONDITIONAL_COMPILATION_SYMBOL]
    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    [System.CodeDom.Compiler.GeneratedCode("[PROJECT_NAME]", "See package version number")]
    internal
#else
    public
#endif
    class [PROJECT_NAME_CLASSNAME_PREFIX]DummyFactory : Default[PROJECT_NAME_CLASSNAME_PREFIX]DummyFactory
    {
        public [PROJECT_NAME_CLASSNAME_PREFIX]DummyFactory()
        {
            /* Add any overriding or custom registrations here. */
        }
    }
}
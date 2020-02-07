﻿// --------------------------------------------------------------------------------------------------------------------
// <copyright file="$secondPrefixElement$BsonConfiguration.cs" company="Naos Project">
//    Copyright (c) Naos Project 2019. All rights reserved.
// </copyright>
// --------------------------------------------------------------------------------------------------------------------

namespace $projectName$
{
    using System;
    using System.Collections.Generic;
    using OBeautifulCode.Serialization.Bson;

    /// <summary>
    /// Implementation for the <see cref="$secondPrefixElement$" /> domain.
    /// </summary>
    public class $secondPrefixElement$JsonConfiguration : BsonConfigurationBase
    {
        /// <inheritdoc />
        protected override IReadOnlyCollection<Type> TypesToAutoRegister => new[]
        {
        };
    }
}
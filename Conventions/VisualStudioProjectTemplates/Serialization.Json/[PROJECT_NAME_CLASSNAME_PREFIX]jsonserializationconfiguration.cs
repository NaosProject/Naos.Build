﻿// --------------------------------------------------------------------------------------------------------------------
// <copyright file="[PROJECT_NAME_CLASSNAME_PREFIX]JsonSerializationConfiguration.cs" company="Naos Project">
//    Copyright (c) Naos Project 2019. All rights reserved.
// </copyright>
// --------------------------------------------------------------------------------------------------------------------

namespace [PROJECT_NAME]
{
    using System;
    using System.Collections.Generic;

    using OBeautifulCode.Serialization.Json;

    /// <inheritdoc />
    public class [PROJECT_NAME_CLASSNAME_PREFIX]JsonSerializationConfiguration : JsonSerializationConfigurationBase
    {
        /// <inheritdoc />
        protected override IReadOnlyCollection<Type> TypesToAutoRegister => new Type[]
        {
            // ADD TYPES TO REGISTER HERE
        };
    }
}